package citrux.core;


import citrux.view.ACitruxView;
import openfl.Vector;
import Void;
import citrux.system.Entity;

/**
	 * Take a look on the 2 respective states to have some information on the functions.
	 */
interface IState {

    public function destroy():Void;

    public var view(get_view, null):ACitruxView;

    public function initialize():Void;

    public function update(timeDelta:Float):Void;

    public function add(object:CitruxObject):CitruxObject;

    public function addEntity(entity:Entity):Entity;

    public function remove(object:CitruxObject):Void;

    public function removeImmediately(object:CitruxObject):Void;

    public function getObjectByName(name:String):CitruxObject;

    public function getFirstObjectByType(type:Class):CitruxObject;

    public function getObjectsByType(type:Class):Vector<CitruxObject>;

    public function get_view():ACitruxView ;
}