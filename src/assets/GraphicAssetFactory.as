package assets
{
	import flash.display.Loader;
	import flash.events.EventDispatcher;
	import flash.net.URLRequest;
	
	import mx.controls.SWFLoader;

	[Bindable]
	public class GraphicAssetFactory extends EventDispatcher
	{
		
		public function GraphicAssetFactory()
		{
			
		}
		
		public static function getAlteratingColorsForList():Array{
			var arr:Array = [0xffaace,0xdd88ac]; 
			return arr;
		}
		
		public static function getLoadingMovieClip():Loader{
			var request:URLRequest = new URLRequest("assets/swiffs/loading6.swf");
			var loader:Loader = new Loader()
			loader.load(request);
			return loader;
		}
	}
}