package services
{
	import com.adobe.ep.notifications.Notification;
	import com.adobe.ep.notifications.NotificationAlertPolicy;
	import com.adobe.ep.notifications.NotificationEvent;
	import com.adobe.ep.notifications.NotificationIconType;
	import com.adobe.ep.notifications.NotificationManager;
	import com.facebook.graph.FacebookMobile;
	import com.squidzoo.eventSystem.EventCentral;
	import com.squidzoo.eventSystem.events.CustomDataEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.StatusEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import mx.core.FlexGlobals;

	public class NotificationPollService extends EventDispatcher
	{
		// You can set this value to anything you want (and use various values)
		// You can then pass this value into the notification manager to cancel notifications of a specified type
		private const NOTIFICATION_CODE:String="MY_CUSTOM_NOTIFICATION";

		private var _timer:Timer;

		private var _numCalls:int=100000;
		private var _waitTime:int;
		private var _notificationManager:NotificationManager;
		private var _config:Config;
		private var _pollFrequency:String;
		private var _timerDelay:int;
		private var _service:FBService;

		public function NotificationPollService(config:Config)
		{
			_config=config;

			_service = new FBService();
			_service.addEventListener(FBService.POLL_NOTIFICATIONS_ERROR,onGetNotificationsError);
			_service.addEventListener(FBService.POLL_NOTIFICATIONS_SUCCESS, onGetNotificationsSuccess);
			
			initNotificationManager();
			getPollFrequencyConfig();
			setTimerWaitPeriod();
		}
				
		private function initNotificationManager():void
		{
			try
			{
				_notificationManager=new NotificationManager();
			}
			catch (ae:ArgumentError)
			{
				trace("The notification native extension has\n no support for this platform.");
				//TODO: display error message to user;
			}
			
			_notificationManager.addEventListener(NotificationEvent.NOTIFICATION_ACTION, onNotificationActionEvent);
		}
		
		private function getPollFrequencyConfig():void
		{
			
			if (_config.getProperty(Config.POLL_FREQUENCY))
			{
				var pollFrequency:String=_config.getProperty(Config.POLL_FREQUENCY).toString();
			}
			
			if (pollFrequency == null)
			{
				_pollFrequency=_config.getDefaultPollFrequency();
			}
			else
			{
				_pollFrequency=pollFrequency;
			}
		}	
		
		private function setTimerWaitPeriod():void
		{
			switch (_pollFrequency)
			{
				case Config.POLL_FREQUENCY_NEVER:
					//do nothing: _pollFrequency == Config.POLL_FREQUENCY_NEVER prevents timer from starting in start()
					break;
				case Config.POLL_FREQUENCY_ONE_MINUTE:
					_timerDelay=Config.ONE_MINUTE_IN_MILLISECONDS;
					break;
				case Config.POLL_FREQUENCY_FIFTEEN_MINUTES:
					_timerDelay=Config.FIFTEEN_MINUTES_IN_MILLISECONDS;
					break;
				case Config.POLL_FREQUENCY_THIRTY_MINUTES:
					_timerDelay=Config.THIRTY_MINUTES_IN_MILLISECONDS;
					break;
				case Config.POLL_FREQUENCY_ONE_HOUR:
					_timerDelay=Config.ONE_HOUR_IN_MILLISECONDS;
					break;
			}
		}

		public function reset():void
		{
			getPollFrequencyConfig();
			setTimerWaitPeriod();
			start();
		}

		public function start():void
		{
			trace("NPS start timer");

			if (_pollFrequency == Config.POLL_FREQUENCY_NEVER)
			{
				trace("_pollFrequency == never");
				return;
			}

			if (_timer && _timer.running)
			{
				_timer.stop();
			}
			_timer=new Timer(_timerDelay, _numCalls);
			_timer.addEventListener(TimerEvent.TIMER, onTick);
			_timer.start();
		}
		
		private function onTick(event:TimerEvent):void
		{
			trace("NPS onTick")
			_service.pollNotifications();
		}

		protected function onGetNotificationsError(event:Event):void
		{
			// TODO Auto-generated method stub
			
		}	

		private function onGetNotificationsSuccess(event:Event):void
		{	
				if (_service.notifications.length > 0)
				{
					sendNotification(_service.notifications.length)
				}
		}
		
		private function sendNotification(numNotifications:int):void
		{
			if (!_notificationManager || !_notificationManager.isSupported)
			{
				trace("Notifications can't be dispatched on this platform.");
				return;
			}

			var n:Notification=createNewNotification(numNotifications);

			_notificationManager.notifyUser(NOTIFICATION_CODE, n);
		}

		private function createNewNotification(numNotifications:int):Notification
		{
			var n:Notification=new Notification();

			n.tickerText="Friendify Notification" + (numNotifications > 1 ? "s" : "");
			n.title="Friendify";
			n.body="You have " + numNotifications + " new notification" + (numNotifications > 1 ? "s" : "");

			// Allows you to control whether an alert is dispathed with each notification, or just the first notification.
			n.alertPolicy=NotificationAlertPolicy.EACH_NOTIFICATION;

			// On Android, specifies whether the notification persists when the user taps it in the notification area
			n.cancelOnSelect=true;

			//the app will be brought to the foreground if it was in the background or launched if it had been shutdown.
			// On Android, the way to perform an action is not visible, it is performed by selecting 
			// the notification from the notification list (window shade)."
			n.hasAction=true;
			n.actionData="customAction";

			// Allows you to set the Android notification icon
			n.iconType=NotificationIconType.MESSAGE;

			// On both Android and iOS, lets you set a number on the icon or application badge
			n.numberAnnotation=numNotifications;

			// On Android, "ongoing" notifications aren't cleared with the clear button
			n.ongoing=false;

			n.playSound=false;
			n.vibrate=false;
			n.repeatAlertUntilAcknowledged=false;

			return n;
		}
		
		private function onNotificationActionEvent(ne:NotificationEvent):void
		{
			trace("Notification action received. Type: " + ne.actionData);
			EventCentral.getInstance().dispatchEvent(new CustomDataEvent(CustomDataEvent.NOTIFICATION_TAPPED_IN_STATUS_BAR, null));
		}

	}
}
