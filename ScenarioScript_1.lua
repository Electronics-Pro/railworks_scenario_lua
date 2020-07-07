-- true/false defn
FALSE = 0
TRUE = 1

-- condition return values
CONDITION_NOT_YET_MET = 0
CONDITION_SUCCEEDED = 1
CONDITION_FAILED = 2

-- Message types
MT_INFO = 0   -- large centre screen pop up
MT_ALERT = 1  -- top right alert message

MSG_TOP = 1
MSG_VCENTRE = 2
MSG_BOTTOM = 4
MSG_LEFT = 8
MSG_CENTRE = 16
MSG_RIGHT = 32

MSG_SMALL = 0
MSG_REG = 1
MSG_LRG = 2

function DisplayRecordedMessage(messagename)
	SysCall("RegisterRecordedMessage","StartDisplay" ..messagename,"StopDisplay" ..messagename)
end

function StartDisplayCamText()
	SysCall("ScenarioManager:ShowInfoMessageExt","Camera Controls","msgcamcon.html",0,MSG_VCENTRE+MSG_CENTRE,MSG_REG,TRUE)
end

function StopDisplayCamText()
end

function StartDisplayIntroText()
	SysCall("ScenarioManager:ShowInfoMessageExt","Welcome to Indian Railways Academy","msgstrt.html",0,MSG_VCENTRE+MSG_CENTRE,MSG_REG,TRUE)
end

function StopDisplayIntroText()
end

function StartDisplayDepText()
	SysCall("ScenarioManager:ShowInfoMessageExt","Locomotive Controls","msgloccon.html",0,MSG_VCENTRE+MSG_CENTRE,MSG_REG,TRUE)
end

function StopDisplayDepText()
end

function StartDisplayRevText()
	SysCall("ScenarioManager:ShowInfoMessageExt","The Reverser","msglocconrev.html",0,MSG_VCENTRE+MSG_CENTRE,MSG_REG,TRUE)
end

function StopDisplayRevText()
end

function StartDisplayBrakeText()
	SysCall("ScenarioManager:ShowInfoMessageExt","The Brakes","msglocconbrake.html",0,MSG_VCENTRE+MSG_CENTRE,MSG_REG,TRUE)
end

function StopDisplayBrakeText()
end

function StartDisplayThrText()
	SysCall("ScenarioManager:ShowInfoMessageExt","The Throttle","msglocconthr.html",0,MSG_VCENTRE+MSG_CENTRE,MSG_REG,TRUE)
end

function StopDisplayThrText()
end

function StartDisplaySpeedLim()
	SysCall("ScenarioManager:ShowInfoMessageExt","Speed Limits","msgspdlim.html",0,MSG_VCENTRE+MSG_CENTRE,MSG_REG,TRUE)
end

function StopDisplaySpeedLim()
end

function StartDisplaySpeedLim2()
	SysCall("ScenarioManager:ShowInfoMessageExt","Speed Limit End","msgspdlim2.html",0,MSG_VCENTRE+MSG_CENTRE,MSG_REG,TRUE)
end

function StopDisplaySpeedLim2()
end

function StartDisplaySpeedLim3()
	SysCall("ScenarioManager:ShowInfoMessageExt","Speed Limit Warning","msgspdlim3.html",0,MSG_VCENTRE+MSG_CENTRE,MSG_REG,TRUE)
end

function StopDisplaySpeedLim3()
end

function StartDisplayOvrSpdWarn()
	SysCall("ScenarioManager:ShowInfoMessageExt","Speed Limit Warning","msgovrspdwar.html",0,MSG_VCENTRE+MSG_CENTRE,MSG_REG,TRUE)
end

function StopDisplayOvrSpdWarn()
end

function StartDisplayOvrSpdFinWarn()
	SysCall("ScenarioManager:ShowInfoMessageExt","Speed Limit Warning","msgovrspdfwar.html",0,MSG_VCENTRE+MSG_CENTRE,MSG_REG,TRUE)
end

function StopDisplayOvrSpdFinWarn()
end

function OnEvent(event)
	if (event == "TrigScenFail") then
		SysCall("ScenarioManager:TriggerScenarioFailure","You were supposed to stop at this siding. It seems you are not good enough to become a IR Locopilot.")
	end

	if (event == "TrigScenSuc") then
		SysCall("ScenarioManager:TriggerScenarioComplete","Great Job Sayandeep! You really have a great potential to become a locopilot. Will see you tomorrow.")
	end

	if (event == "SpdLim") then
		ovrspd = 23.61
		DisplayRecordedMessage("SpeedLim2")
	end

	if (event == "SpdLim2") then
		DisplayRecordedMessage("SpeedLim3")
	end

	if (event == "lockcont") then
		SysCall("ScenarioManager:LockControls")
	end

	if (event == "startup") then
		DisplayRecordedMessage("IntroText")
	end

	if (event == "startcine") then
		SysCall("CameraManager:ActivateCamera","startCinematic",0)
		SysCall("ScenarioManager:BeginConditionCheck","NoMoveCheck")
	end

	if (event == "cabcam") then
		SysCall("CameraManager:ActivateCamera","CabCamera",0)
		SysCall("ScenarioManager:UnlockControls")
	end

	if (event == "camcontmsg") then
		DisplayRecordedMessage("CamText")
	end

	if (event == "depcam") then
		SysCall("CameraManager:ActivateCamera","CabCamera",0)
		DisplayRecordedMessage("DepText")
	end

	if (event == "deprev") then
		SysCall("WindowsManager:HighlightControl","Reverser",5,0)
		SysCall("ScenarioManager:LookAtControl","Reverser",5,5,0.8)
		DisplayRecordedMessage("RevText")
	end

	if (event == "depbrake") then
		SysCall("WindowsManager:HighlightControl","TrainBrakeControl",5,0)
		SysCall("ScenarioManager:LookAtControl","TrainBrakeControl",5,5,0.8)
		DisplayRecordedMessage("BrakeText")
	end

	if (event == "depthr") then
		SysCall("ScenarioManager:EndConditionCheck","NoMoveCheck")
		SysCall("WindowsManager:HighlightControl","Regulator",5,0)
		SysCall("ScenarioManager:LookAtControl","Regulator",5,5,0.8)
		DisplayRecordedMessage("ThrText")
	end

	if (event == "depres") then
		ovrspd = 5.55
		ovrspdtype = 0
		SysCall("ScenarioManager:BeginConditionCheck","StartMovingCondition")
		SysCall("ScenarioManager:BeginConditionCheck","OverspeedCheck")
	end

	if (event == "CheckSpeedEvent") then
		ovrspdchk = 1
		SysCall("ScenarioManager:UnlockControls")
	end
end

function TestCondition(condition)
	if(condition == "NoMoveCheck") then
		speed = SysCall("PlayerEngine:GetSpeed")
		if(speed > 0.1) then
			SysCall("ScenarioManager:TriggerScenarioFailure","You were not supposed to touch anything before I say to do so. It seems you are not good enough to become a IR Locopilot.")
			return CONDITION_SUCCEEDED
		end
		return CONDITION_NOT_YET_MET
	end

	if(condition == "StartMovingCondition") then
		speed = SysCall("PlayerEngine:GetSpeed")
		if(speed > 1.39) then
			DisplayRecordedMessage("SpeedLim")
			SysCall("ScenarioManager:RestoreCameraToDefault",2)
			return CONDITION_SUCCEEDED
		end
		return CONDITION_NOT_YET_MET
	end

	if(condition == "OverspeedCheck") then
		speed = SysCall("PlayerEngine:GetSpeed")
		if(speed > ovrspd) then
			if(ovrspdtype == 0) then
				ovrspdchk = 0
				ovrspdtype = 1
				DisplayRecordedMessage("OvrSpdWarn")
				SysCall("ScenarioManager:TriggerDeferredEvent","CheckSpeedEvent",20)
				return CONDITION_NOT_YET_MET
			end
			if(ovrspdchk == 1) then
				if(ovrspdtype == 1) then
					ovrspdchk = 0
					ovrspdtype = 2
					DisplayRecordedMessage("OvrSpdFinWarn")
					SysCall("PlayerEngine:SetControlValue","Regulator",0,0)
					SysCall("PlayerEngine:SetControlValue","TrainBrakeControl",0,1)
					SysCall("ScenarioManager:LockControls")
					SysCall("ScenarioManager:TriggerDeferredEvent","CheckSpeedEvent",10)
					return CONDITION_NOT_YET_MET
				end
				if(ovrspdtype == 2) then
					SysCall("ScenarioManager:TriggerScenarioFailure","I give up, you're too bad at listening to instructions and are not good enough to become a IR Locopilot.")
					return CONDITION_SUCCEEDED
				end
			end
			return CONDITION_NOT_YET_MET
		end
	end
end
