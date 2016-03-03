package system.loader
{
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;

	public class LoaderManager
	{
		private static var _loaderManager:LoaderManager = null;
		private var _loaderQueue:Array = null;
		private var _urlLoaderQueue:Array = null;
		private var _urlResQueue:Array = null;
		private var _loaderResQueue:Array = null;
		private var _loader2ResMap:Dictionary = null;
		public function LoaderManager()
		{
			_loader2ResMap = new Dictionary();
			
			_loaderQueue = [];
			_loaderResQueue = [];
			_loaderQueue.push(new Loader());
			
			_urlLoaderQueue = [];
			_urlResQueue = [];
			_urlLoaderQueue.push(new URLLoader());
			
			var i:int=0;
			for(i=0;i<_loaderQueue.length;++i){
				var loader:Loader = _loaderQueue[i];
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE,onLoaderComplete);
			}
			for(i=0;i<_urlLoaderQueue.length;++i){
				var urlLoader:URLLoader = _urlLoaderQueue[i];
				urlLoader.addEventListener(Event.COMPLETE,onURLLoaderComplete);
			}
		}
		
		protected function onLoaderComplete(event:Event):void
		{
			var loader:Loader = (event.target as LoaderInfo).loader;
			var res:Res = _loader2ResMap[loader];
			res.data = loader.content;
			res.completeNotify();
			loader.unload();
			_loaderQueue.push(loader);
			load();
		}
		
		protected function onURLLoaderComplete(event:Event):void
		{
			var urlLoader:URLLoader = (event.target as URLLoader);
			var res:Res = _loader2ResMap[urlLoader];
			res.data = ResDecoder.parseTextData(urlLoader.data);
			res.completeNotify();
			urlLoader.data = null;
			_urlLoaderQueue.push(urlLoader);
			load();
		}
		
		public function loadRes(url:String,completeListener:Function=null,
								progressListener:Function = null):void{
			var res:Res = ResManager.instance().getRes(url);
			if(res.isReady()){
				completeListener(res);
				return;
			}
			else{
				var type:int = ResDecoder.getResLoadType(url);
				if(ResDecoder.TYPE_DISPLAYOBJECT == type){
					_loaderResQueue.push(res);
				}else if(ResDecoder.TYPE_TEXT == type){
					_urlResQueue.push(res);
				}
				res.addListener(new LoaderListener(completeListener,progressListener));
				load();
			}
		}
		
		public function loadResList(urlList:Array,completeListener:Function=null,
									progressListener:Function = null):void{
			if(!urlList.length){
				completeListener.call(null,null);
				return;
			}
			var resListListener:LoaderListListener = new LoaderListListener(urlList,completeListener);
			for(var key:String in urlList){
				loadRes(urlList[key],resListListener.handler);
			}
		}
		
		private function load():void
		{
			loadLoader();
			loadUrlLoader();
		}
		
		private function loadUrlLoader():void
		{
			if(_urlLoaderQueue.length && _urlResQueue.length){
				var res:Res = _urlResQueue.shift();
				var loader:URLLoader = _urlLoaderQueue.pop();
				_loader2ResMap[loader] = res;
				loader.load(new URLRequest(res.url));
			}
		}
		
		private function loadLoader():void{
			if(_loaderQueue.length && _loaderResQueue.length){
				var res:Res = _loaderResQueue.shift();
				var loader:Loader = _loaderQueue.pop();
				_loader2ResMap[loader] = res;
				loader.load(new URLRequest(res.url));
			}
		}
		
		public static function instance():LoaderManager{
			if(!_loaderManager)
				_loaderManager = new LoaderManager();
			return _loaderManager;
		}
	}
}