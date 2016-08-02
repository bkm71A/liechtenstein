package com.incheck.admin.view.constructor {
	import mx.collections.ArrayCollection;

	public interface ITreeConstructor {
		function updateModules(modules : ArrayCollection) : void;

		function updateLocations(locations : ArrayCollection) : void;

		function whenChangeParent(func : Function) : void;

		function refresh();
	}
}
