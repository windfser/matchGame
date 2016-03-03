package system
{
	import flash.utils.Dictionary;

	/**
	 * 事件分发器 
	 * @author fengsser
	 */	
	public class DispatchManager
	{
		private static var _instance:DispatchManager;
		/**观察字典**/
		private var _observersDic:Dictionary;
		/**模块匹配 用来确定模块**/
		private var _mapping:Dictionary;
		
		public function DispatchManager()
		{
			_observersDic = new Dictionary();
			_mapping = new Dictionary;
		}
		
		/**分发**/
		public static function dispatch(type:String,param:Object=null):void{
			instance().execute(type,param);
		}
		
		private static function instance():DispatchManager{
			if(_instance == null){
				_instance = new DispatchManager();
			}
			return _instance;
		}
		
		/**执行**/
		private function execute(type:String,param:Object):void{
			var funcs:Array = _observersDic[type];
			for each(var fun:Function in funcs){
				if(param == null)
				{
					fun.apply(null,null);
				}else
				{
					fun.apply(null,[param]);
				}
			}
		}
		
		/**注册**/
		public static function register(type:String,call:Function, module:String=null, method:String=null):void{
			instance().add(type,call,module,method);
		}
		
		private function add(type:String,call:Function, module:String=null, method:String=null):void{
			var funcs:Array = _observersDic[type];
			_mapping[call] = {'module':module, 'method':method};
			if(funcs == null)
			{
				funcs = [];
				_observersDic[type] = funcs;
			}
			else
			{
				if(funcs.indexOf(call) != -1)
				{
					return;
				}
			}
			funcs.push(call);
		}
		
		/**移除**/
		public static function remove(type:String,call:Function):void{
			instance().remove(type,call);
		}
		
		private function remove(type:String,call:Function):void{
			var funcs:Array = _instance[type];
			if(funcs){
				var index:int = funcs.indexOf(call);
				if(index != -1){
					funcs.splice(index,1);
				}
			}
			if(_mapping[call]){
				_mapping[call] = null;
				delete _mapping[call];
			}
		}
	}
}