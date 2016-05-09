// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: fn_onPlayerDisconnected.sqf
//	@file Author: AgentRev

params ["_id", "_uid", "_name", "_owner", "_jip"];

diag_log format ["Player disconnected: %1 (%2)", _name, _uid];

if (_uid isEqualTo "") exitWith {};

[_unit, _uid, _name] call p_disconnectSave;

if (_unit getVariable ["stats_reset",false]) then {
  [_unit] spawn {
    private["_unit"];
    _unit = _this select 0;
	  if (vehicle _unit != _unit && !isNil "fn_ejectCorpse") then {
  		_unit call fn_ejectCorpse;
  	};
	  _unit call sh_drop_player_inventory;
	  _unit setDamage 1;
	};
}else{ 
	deleteVehicle _unit;
};

private _resend = false;

// Clear player from group invites
{
	if (_uid in _x) then
	{
		currentInvites set [_forEachIndex, -1];
		_resend = true;
	};
} forEach currentInvites;

if (_resend) then
{
	currentInvites = currentInvites - [-1];
	publicVariable "currentInvites";
};
