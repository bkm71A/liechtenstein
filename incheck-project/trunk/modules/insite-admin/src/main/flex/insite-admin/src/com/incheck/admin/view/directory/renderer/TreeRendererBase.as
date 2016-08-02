package com.incheck.admin.view.directory.renderer {
	import com.incheck.admin.model.Channel;
	import com.incheck.admin.model.Module;

	import flash.display.Bitmap;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;

	import mx.controls.listClasses.IListItemRenderer;
	import mx.controls.treeClasses.TreeItemRenderer;
	import mx.core.BitmapAsset;

	[Event(type="com.incheck.admin.view.directory.renderer.ModuleRendererEvent", name="moduleClicked")]
	[Event(type="com.incheck.admin.view.directory.renderer.ModuleRendererEvent", name="channelClicked")]
	public class TreeRendererBase extends TreeItemRenderer implements IListItemRenderer {

		[Embed(source='/../imgs/channel.png')]
		protected static const CHANNEL_EXTRA_ICON : Class;

		private var titleLabel : TextField;
		private var extraIcon : Bitmap;

		override protected function createChildren() : void {
			super.createChildren();

			titleLabel = new TextField();
			var format : TextFormat = new TextFormat("Verdana", 12);
			titleLabel.defaultTextFormat = format;
			titleLabel.x = 55;
			titleLabel.y = 15;
			titleLabel.selectable = false;
			addChild(titleLabel);
			extraIcon = new Bitmap();
			extraIcon.x = 35;
			extraIcon.y = 5;
			addChild(extraIcon);
		}


		override public function set data(value : Object) : void {
			super.data = value;
			if (model && titleLabel) {
				titleLabel.textColor = 0x51a882;
			}
			addEventListener(MouseEvent.CLICK, onClick);
		}

		public function set titleLabelText(value : String) : void {
			titleLabel.text = value ? value : "";
		}

		public function set extraIconBitmapData(value : Class) : void {
			extraIcon.bitmapData = value ? BitmapAsset(new value).bitmapData : null;
		}

		private function onClick(event : MouseEvent) : void {
			if (model) {
				onModuleClick();
			} else {
				onChannelClick();
			}
		}

		protected function onModuleClick() : void {
			var event : ModuleRendererEvent = new ModuleRendererEvent(ModuleRendererEvent.MODULE_CLICKED);
			event.module = model;
			dispatchEvent(event);
		}

		protected function onChannelClick() : void {
			var event : ModuleRendererEvent = new ModuleRendererEvent(ModuleRendererEvent.CHANNEL_CLICKED);
			event.channel = channel;
			dispatchEvent(event);
		}

		[Bindable("dataChange")]
		protected function get model() : Module {
			return data as Module;
		}

		[Bindable("dataChange")]
		protected function get channel() : Channel {
			return data as Channel;
		}

		override protected function updateDisplayList(unscaledWidth : Number, unscaledHeight : Number) : void {
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			label.x = 55;
		}
	}
}
