package citrux.system;
import openfl.utils.Object;
import openfl.errors.Error;
import openfl.Vector;
import citrux.core.CitruxObject;

/**
	 * A game entity is compound by components. The entity serves as a link to communicate between components.
	 * It extends the CitruxObject class to enjoy its params setter.
	 */
class Entity extends CitruxObject {

    public var _components(get_components, null):Vector<Component>;

    public function Entity(name:String, params:Object = null) {

        updateCallEnabled = true;

        if (params == null)
            params = {type:"entity"};
        else
            params["type"] = "entity";

        super(name, params);

        _components = new Vector<Component>();
    }

/**
		 * Add a component to the entity.
		 */

    public function add(component:Component):Entity {

        doAddComponent(component);

        return this;
    }

    function doAddComponent(component:Component):Bool {
        if (component.name == "") {
            trace("A component name was not specified. This might cause problems later.");
        }

        if (lookupComponentByName(component.name))
            throw Error("A component with name '" + component.name + "' already exists on this entity.");

        if (component.entity) {
            if (component.entity == this) {
                trace("Component with name '" + component.name + "' already has entity ('" + this.name + "') defined. Manually defining components is no longer needed");
                _components.push(component);
                return true;
            }

            throw Error("The component '" + component.name + "' already has an owner. ('" + component.entity.name + "')");
        }

        component.entity = this;
        _components.push(component);
        return true;
    }

/**
		 * Remove a component from the entity.
		 */

    public function remove(component:Component):Void {

        var indexOfComponent:Int = _components.indexOf(component);
        if (indexOfComponent != -1)
            _components.splice(indexOfComponent, 1)[0].destroy();
    }

/**
		 * Search and return first componentType's instance found in components
		 *
		 * @param 	componentType  Component instance class we're looking for
		 * @return 	Component
		 */

    public function lookupComponentByType(componentType:Class):Component {
        var component:Component = null;
        var filteredComponents:Vector<Component> = Lambda.filter(_components,
        function(item:Component):Bool {

            return Std.is(item, componentType);

        });

        if (filteredComponents.length != 0) {
            component = filteredComponents[0];
        }

        return component;
    }

/**
		 * Search and return all componentType's instance found in components
		 *
		 * @param 	componentType  Component instance class we're looking for
		 */

    public function lookupComponentsByType(componentType:Class):Vector<Component> {
        var filteredComponents:Vector<Component> = Lambda.filter(_components,
        function(item:Component):Bool {

            return Std.is(item, componentType);

        });

        return filteredComponents;
    }

/**
		 * Search and return a component using its name
		 *
		 * @param 	name Component's name we're looking for
		 * @return 	Component
		 */

    public function lookupComponentByName(name:String):Component {
        var component:Component = null;

        var filteredComponents:Vector<Component> = Lambda.filter(_components,
        function(item:Component):Bool {

            return item.name == name;

        });



        if (filteredComponents.length != 0) {
            component = filteredComponents[0];
        }

        return component;
    }

/**
		 * After all the components have been added call this function to perform an init on them.
		 * Mostly used if you want to access to other components through the entity.
		 * Components initialization will be perform according order in which components
		 * has been add to entity
		 */

    override public function initialize(poolObjectParams:Object = null):Void {

        super.initialize();

        Lambda.foreach(_components, function(item:Component):Void {
            item.initialize();
        });


    }

/**
		 * Destroy the entity and its components.
		 * Components destruction will be perform according order in which components
		 * has been add to entity
		 */

    override public function destroy():Void {

        Lambda.foreach(_components, function(item:Component):Void {
            item.destroy();
        });


        _components = null;

        super.destroy();
    }

/**
		 * Perform an update on all entity's components.
		 * Components update will be perform according order in which components
		 * has been add to entity
		 */

    override public function update(timeDelta:Float):Void {

        Lambda.foreach(_components, function(item:Component):Void {
            item.update(timeDelta);
        });


    }

    private function get_components():Vector<Component> {
        return _components;
    }
}

