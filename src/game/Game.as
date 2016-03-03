package game
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.geom.Point;
	
	import system.DispatchManager;
	import system.loader.LoaderManager;
	import system.loader.Res;
	import system.loader.ResPath;
	import system.ui.PanelManager;

	public class Game
	{
		private static var _app:Main = null;
		private static var _instance:Game = null;
		private var _stage:Stage = null;
		private var _bg:DisplayObject = null;
		private var _bgLayer:Sprite;
		private var _panelLayer:Sprite;
		
		public function Game()
		{
			_bgLayer = new Sprite();
			_panelLayer = new Sprite();
		}
		
		public function stageW():Number{
			return _stage.width;
		}
		
		public function stageH():Number{
			return _stage.height;
		}
		
		public function setUp(app:Main):void{
			if(_app)
				return;
			_app = app;
			_stage = app.stage;
			_stage.addChild(_bgLayer);
			_stage.addChild(_panelLayer);
			PanelManager.instance().setUp(_panelLayer);
			registerPanel();
			registerListener();
			loadBgThenStart();	
		}
		
		private function registerPanel():void
		{
			PanelManager.instance().registerPanel(StartPanel.PANELNAME,StartPanel);
			PanelManager.instance().registerPanel(PlayPanel.PANELNAME,PlayPanel);
		}
		
		private function registerListener():void
		{
			DispatchManager.register(GameEvent.CLICK_STARTPANEL_PLAY,function ():void{
				PanelManager.instance().closePanel(StartPanel.PANELNAME);
				PanelManager.instance().showPanel(PlayPanel.PANELNAME);
			},"开始面板","点击开始按钮");
		}
		
		private function loadBgThenStart():void
		{
			LoaderManager.instance().loadRes(ResPath.ROOT+"bg/bg.jpg",function (res:Res):void{
				_bg = res.data;
				if(stageW()>_bg.width)
					_bg.x = (stageW() - _bg.width)>>1;
				if(stageH()>_bg.height)
					_bg.y = (stageH() - _bg.height)>>1;
				_bgLayer.addChild(_bg);
				PanelManager.instance().showPanel(StartPanel.PANELNAME);
			});
			
		}
		
		public function getPosition():Point{
			return new Point(_bg.x,_bg.y);
		}
		
		public static function instance():Game{
			if(!_instance){
				_instance = new Game();
			}
			return _instance;
		}
	}
}