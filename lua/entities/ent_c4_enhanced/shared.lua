AddCSLuaFile()

CreateConVar("c4_enhanced_mintimer", 0, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "The minimum timer C4 can be set to.", 0, 3599)
CreateConVar("c4_enhanced_maxtimer", 3599, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "The maximum timer C4 can be set to.", 0, 3599)
CreateConVar("c4_enhanced_damage", 400, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "How much damage C4 does when it explodes")

local convarMin = GetConVar("c4_enhanced_mintimer")
local convarDamage = GetConVar("c4_enhanced_damage")

ENT.Base = "base_anim"
ENT.Type = "anim"

ENT.RenderGroup = RENDERGROUP_BOTH

ENT.PrintName = "C4"

ENT.Model = Model("models/weapons/w_c4_planted.mdl")

ENT.PhysgunDisabled = true

if CLIENT then
	include("cl_ui.lua")
else
	AddCSLuaFile("cl_ui.lua")

	include("sv_net.lua")
end

game.AddParticles("particles/gb5_high_explosive.pcf")
game.AddParticles("particles/gb5_high_explosive_2.pcf")

PrecacheParticleSystem("high_explosive_main")

function ENT:Initialize()
	self:SetModel(self.Model)

	if SERVER then
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_NONE)

		self:SetUseType(SIMPLE_USE)

		self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	end

	self:SetTimer(convarMin:GetInt())
end

function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "Timer")

	self:NetworkVar("Float", 0, "LastBeep")
	self:NetworkVar("Float", 1, "ExplodeTimer")

	self:NetworkVar("Entity", 0, "Instigator")
end

function ENT:IsArmed()
	return self:GetExplodeTimer() > 0
end

if CLIENT then
	surface.CreateFont("C4.Enhanced.UIWorld", {
		font = "LCD AT&T Phone Time/Date", -- Christ
		size = 300,
		weight = 500
	})

	function ENT:DrawTranslucent()
		if not self:IsArmed() and CurTime() % 1 > 0.5 then
			return
		end

		cam.Start3D2D(self:LocalToWorld(Vector(4.3, -1.8, 8.85)), self:LocalToWorldAngles(Angle(-180, 90, 180)), 0.011)
			local time = self:IsArmed() and math.ceil(self:GetExplodeTimer() - CurTime()) or self:GetTimer()

			draw.DrawText(os.date("%M:%S", time), "C4.Enhanced.UIWorld", 0, 0, Color(151, 12, 12))
		cam.End3D2D()
	end
else
	function ENT:Think()
		self:NextThink(CurTime())

		if not self:IsArmed() then
			return true
		end

		if self:GetExplodeTimer() <= CurTime() then
			local pos = self:WorldSpaceCenter()

			self:EmitSound("weapons/c4_enhanced/mine_explosion.mp3", 140)

			ParticleEffect("high_explosive_main", pos, angle_zero)

			local explo = ents.Create("env_explosion")

			explo:SetOwner(self:GetInstigator())
			explo:SetPos(pos)
			explo:SetKeyValue("iMagnitude", convarDamage:GetInt())
			explo:SetKeyValue("spawnflags", 576)
			explo:Spawn()
			explo:Activate()
			explo:Fire("Explode")

			SafeRemoveEntity(self)

			return true
		end

		local nextBeep = math.Clamp(math.Remap(self:GetExplodeTimer() - CurTime(), 1, 5, 0.1, 1), 0.1, 1)

		if CurTime() - self:GetLastBeep() >= nextBeep then
			self:EmitSound("weapons/c4_enhanced/c4_click.wav", 80)
			self:SetLastBeep(CurTime())
		end
	end

	function ENT:Use(ply)
		if self:IsArmed() then
			return
		end

		net.Start("C4EnhancedOpenMenu")
			net.WriteEntity(self)
		net.Send(ply)
	end

	function ENT:StartTimer(ply)
		self:SetInstigator(ply)
		self:SetExplodeTimer(CurTime() + self:GetTimer())
		self:SetLastBeep(CurTime())
	end

	function ENT:StopTimer()
		self:SetTimer(math.ceil(self:GetExplodeTimer() - CurTime()))

		self:SetInstigator(NULL)
		self:SetExplodeTimer(0)
		self:SetLastBeep(0)
	end
end
