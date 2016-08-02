package com.incheck.admin.controller {
	import com.incheck.admin.event.AdminServiceEvent;
	import com.incheck.admin.event.ChannelsEvent;
	import com.incheck.admin.event.RefreshEvent;
	import com.incheck.admin.model.Channel;
	import com.incheck.admin.model.Module;
	import com.incheck.admin.service.AdminService;
	import com.incheck.admin.view.channels.IChannels;

	public class ChannelsController extends BaseController {
		private var view : IChannels;
		private var module : Module;
		private var channel : Channel;

		public function ChannelsController(view : IChannels, service : AdminService) {
			this.service = service;
			this.view = view;
			this.view.whenSaveChannel(onSaveChannel);
		}

		public function createNewChannel(module : Module) : void {
			isNew = true;
			this.module = module;
			this.channel = new Channel();
			view.editChannel(this.module, this.channel);
		}

		public function editChannel(module : Module, channel : Channel) : void {
			isNew = false;
			this.module = module;
			this.channel = channel;
			view.editChannel(this.module, this.channel);
		}

		private function onSaveChannel(module : Module, channel : Channel) : void {
			service.addEventListener(AdminServiceEvent.CHANNEL_SAVED, onChannelSaved);
			service.saveChannel(channel.id, module.id, channel.channelID, channel.channelType, channel.connectorNum, channel.offset);
		}

		private function onChannelSaved(serviceEvent : AdminServiceEvent) : void {
			service.removeEventListener(AdminServiceEvent.CHANNEL_SAVED, onChannelSaved);
			if (isNew) {
				var event : ChannelsEvent = new ChannelsEvent(ChannelsEvent.CHANNEL_CREATED);
				channel.id = serviceEvent.newId;
				event.channel = channel;
				event.module = module;
				dispatchEvent(event);
			}
			isNew = false;
			var refreshEvent : RefreshEvent = new RefreshEvent(RefreshEvent.DATA_UPDATED);
			dispatchEvent(refreshEvent);
		}
	}
}