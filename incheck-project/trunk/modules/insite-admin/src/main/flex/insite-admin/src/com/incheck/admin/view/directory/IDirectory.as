package com.incheck.admin.view.directory {
import mx.collections.ArrayCollection;

public interface IDirectory {

    function whenModuleSelected (func : Function) : void;

    function whenChannelSelected(func:Function):void;

    function updateModules(modules : ArrayCollection) : void;
}
}
