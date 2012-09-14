package services
{
	import flash.events.EventDispatcher;
	
	import spark.managers.PersistenceManager;
	
	public class Config extends EventDispatcher
	{	
		public static const POLL_FREQUENCY:String = "poll frequency";
		public static const POLL_FREQUENCY_NEVER:String = "Never";
		public static const POLL_FREQUENCY_ONE_MINUTE:String = "One minute";
		public static const POLL_FREQUENCY_FIFTEEN_MINUTES:String = "Fifteen minutes";
		public static const POLL_FREQUENCY_THIRTY_MINUTES:String = "Thirty minutes";
		public static const POLL_FREQUENCY_ONE_HOUR:String = "One hour";
		public static const SELECTED:String = "selected";
		public static const NOT_SELECTED:String = "not selected";
		
		public static const ONE_MINUTE_IN_MILLISECONDS:int = 60000;
		public static const FIFTEEN_MINUTES_IN_MILLISECONDS:int = 900000;
		public static const THIRTY_MINUTES_IN_MILLISECONDS:int = 1800000;
		public static const ONE_HOUR_IN_MILLISECONDS:int = 3600000;
		
	
	private var _persistenceManager:PersistenceManager;
	
	private var _defaultPollFrequency:String;
	private var _pollFrequency:String;
	private var _events:String;
	private var _wall:String;
	private var _groups:String;
	private var _birthdays:String;
	private var _friends:String;
	
	public function Config(persistenceManager:PersistenceManager){
		_persistenceManager = persistenceManager;
		_defaultPollFrequency = Config.POLL_FREQUENCY_THIRTY_MINUTES;
	}
	
	public function getDefaultPollFrequency():String{
		return _defaultPollFrequency;
	}
	
	public function hasSavedData():Boolean{
		return _persistenceManager.load();		
	}
	
	public function setProperty(key:String,value:Object):void{
		trace("set Property: "+key,value);
		_persistenceManager.setProperty(key,value);		
		
	}
	
	public function getProperty(key:String):Object{
		return _persistenceManager.getProperty(key);
	}
	
	public function hasProperty(key:String):Boolean{
		return _persistenceManager.hasOwnProperty(key);
	}
	
	public function clear():void{
		_persistenceManager.clear();
	}
	
	public function clearPollFrequency():void{
		_persistenceManager.setProperty(POLL_FREQUENCY,null);
	}
	

	}
}