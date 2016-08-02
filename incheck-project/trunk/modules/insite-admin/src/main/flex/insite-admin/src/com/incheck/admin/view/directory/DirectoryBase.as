package com.incheck.admin.view.directory {
	import com.incheck.admin.model.Channel;
	import com.incheck.admin.model.Module;
	import com.incheck.admin.view.directory.renderer.ModuleRendererEvent;

	import mx.collections.ArrayCollection;
	import mx.containers.VBox;

	public class DirectoryBase extends VBox implements IDirectory {

		[Bindable]
		protected var modules : ArrayCollection;

		private var whenModuleSelectedFunction : Function;
		private var whenChannelSelectedFunction : Function;

		protected function labelFunction(item : Object) : String {
			if (item is Module) {
				return (item as Module).deviceID;
			} else if (item is Channel) {
				return (item as Channel).channelID;
			}
			return "";
		}

		protected function onModuleClicked(event : ModuleRendererEvent) : void {
			var ind : uint = modules.getItemIndex(event.module);
			whenModuleSelectedFunction(ind ? event.module : null);
		}

		protected function onChannelClicked(event : ModuleRendererEvent) : void {
			var module : Module = findModuleForChannel(event.channel);
			whenChannelSelectedFunction(module, event.channel.channelID != "New" ? event.channel : null);
		}

		public function whenModuleSelected(func : Function) : void {
			whenModuleSelectedFunction = func;
		}

		public function whenChannelSelected(func : Function) : void {
			whenChannelSelectedFunction = func;
		}

		public function updateModules(modules : ArrayCollection) : void {
			this.modules = modules;
		}

		private function findModuleForChannel(channelToSearch : Channel) : Module {
			for each (var module : Module in modules) {
				for each (var channel : Channel in module.children) {
					if (channel == channelToSearch) {
						return module;
					}
				}
			}
			return null;
		}
	}
}
