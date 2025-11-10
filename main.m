close all
clear all

load TAData\quasistatic_0001.mat
run scripts\parameters.m
run paramID\Throttle\ThrottleAirMassFlowIdent.m
run paramID\EngineAirMass\EngineAirMassFlowIdent.m
run paramID\IntakeManifold\IntakeManifoldIdent.m
run paramID\TorqueGen_Inertia\TorqueGen_InertiaIdent.m
run ControllerSynthesis\Linearization.m
