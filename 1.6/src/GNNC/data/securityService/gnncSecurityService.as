package GNNC.data.securityService
{
	import GNNC.data.conn.gnncAMFPhp;
	import GNNC.data.data.gnncData;
	import GNNC.data.data.gnncDataObject;
	import GNNC.data.globals.gnncGlobalStatic;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.remoting.RemoteObject;

	public class gnncSecurityService
	{
		public static const _METHOD_CONNECT_AMF_GLOBAL:String 	= 'amfGlobal';
		public static const _METHOD_CONNECT_AMF_PERSONAL:String = 'amfPersonal';
		public static const _METHOD_CONNECT_FILE:String 		= 'file';
		
		public var _authenticated:Boolean 		= false;
		public var _permissionAccess:Boolean 	= false;
		public var _error:Boolean 				= false;
		
		private var _x:gnncAMFPhp 				= new gnncAMFPhp();
		private var _r:Function 				= function(e:*):void{};
		private var _f:Function 				= function(e:*):void{};
		private var _o:RemoteObject				= new RemoteObject();
		private var _m:String					= '';
		private var _d:String					= '';

		private var _l:String					= 'librarys/files/filesPhp/filePhpSecurityUserLogin.php.old';
		private var _rA:ArrayCollection			= null;
		private var _rO:Object					= null;
		private var _rS:String					= '';
		
		/**
		 * u = user
		 * p = password
		 * r = function result
		 * f = function fault
		 * m = method [ amfPersonal | amfGlobal| file ]
		 * d = destination server amfphp [gnnc]
		 * 
		 * **/
		public function gnncSecurityService(u:Object='',p:Object='',r:Function=null,f:Function=null,m:String='amfPersonal',d:String='')
		{
			if(!u || !p ) return;
			_r = r; //function fault
			_f = f; //function result
			_m = m; //method connecr
			_d = d; //destination server amfphp (gnnc)
			__clearValues();
			__gnncAuthenticateLogin(String(u),String(p));
		}
		
		/** 
		 * ####################################
		 * clear values public variables
		 * ####################################
		 * **/
		private function __clearValues():void
		{
			_authenticated 			= false;
			_permissionAccess 		= false;
			_error					= false;
		}
		
		/** 
		 * ####################################
		 * destroy connectione and clear
		 * ####################################
		 * **/
		public function __cancel():void
		{
			__clearValues();
			
			_rA						= null;
			_rO						= null;
			_rS						= '';
			
			//amf global
			_x.__destroy(); //destroy session/connection
			
			//amf personal
			
			if(!_o.willTrigger(ResultEvent.RESULT))
				return;
			
			_o.removeEventListener	(ResultEvent.RESULT	,__handleResultAmf,false);
			_o.removeEventListener	(FaultEvent.FAULT	,__handleFault,false);

		}
		
		/** 
		 * ####################################
		 * connect database client
		 * ####################################
		 * **/
		private function __gnncAuthenticateLogin(u:String='',p:String=''):void
		{
			__clearValues();

			switch(_m)
			{
				case _METHOD_CONNECT_AMF_GLOBAL:
					
					//work
					_x 						= new gnncAMFPhp();
					_x._allowGlobalError 	= true;
					_x._allowGlobalLoading 	= true;
					_x.TRY = true;
					_x._requestsType 		= "single"; // single last
					_x.__exec				('securityUserLogin',new gnncSecurityUserLogin(u,p),null,'','',__handleResultAmf,__handleFault);
					//new gnncAlert().__alert('@'+u+"#"+p+"%");
					
					break;
				
				case _METHOD_CONNECT_AMF_PERSONAL:
				
					//try
					_o						= new RemoteObject();
					_o.concurrency			= 'single';
					_o.makeObjectsBindable 	= false;
					_o.requestTimeout		= 120;
					_o.destination 			= _d ? _d : gnncGlobalStatic._serverName ? gnncGlobalStatic._serverName : 'gnncServer'; //connect xml file | Server
					_o.source				= '_gnncAmfPhp'; //fileNameAmfphp and(too) nameClass
					_o.addEventListener		(ResultEvent.RESULT	,__handleResultAmf,false,0,true);
					_o.addEventListener		(FaultEvent.FAULT	,__handleFault,false,0,true);
					_o.getOperation			('securityUserLogin').send(new gnncSecurityUserLogin(u,p)); //function and paramnsObject

					/*
					//testing error
					_o.addEventListener(ResultEvent.RESULT,function(e:ResultEvent):void{
						Alert.show("e.headers"+e.headers);
						Alert.show("e.message"+e.message);
						Alert.show("e.result"+e.result);
					});

					_o.addEventListener(FaultEvent.FAULT,function(e:FaultEvent):void{
						Alert.show("e.headers"+e.headers);
						Alert.show("e.message"+e.message);
						Alert.show("e.fault"+e.fault);
					});

					_o.addEventListener(InvokeEvent.INVOKE,function(e:InvokeEvent):void{
						Alert.show("e.message"+e.message);
					});
					*/
					break;

				case _METHOD_CONNECT_FILE:
					
					var e:URLRequest 		= new URLRequest(gnncGlobalStatic._httpDomain + _l + '?' + Math.random());
					e.method				= 'POST';
					e.data					= new gnncSecurityUserLogin(u,p);
					
					var _load:URLLoader 	= new URLLoader(e);
					_load.addEventListener	(Event.COMPLETE,__handleResultFile);
					_load.addEventListener	(IOErrorEvent.IO_ERROR,__handleFault);
					_load.addEventListener	(SecurityErrorEvent.SECURITY_ERROR,__handleFault);

					break;

				default:
					__handleFaultnoMethod.call();
					return;
			}
			
		}
		
		/** 
		 * ####################################
		 * check values
		 * ####################################
		 * **/
		protected function __checkValues(a:Object,i:uint):void 
		{
			__clearValues();
			
			if( i == 1 )
			{
				_authenticated = true;
				
				if( String(a[0]['ACCESS']).toLowerCase() === 'true' )
					
					_permissionAccess = true;
			}
			
			if(_authenticated && _permissionAccess)
			{
				__setValues(a[0]);
				return;
			}
			
			_f.call();
			
		}
		
		/** 
		 * ####################################
		 * if ok, set values
		 * ####################################
		 * **/
		protected function __setValues(a:Object):void 
		{
			gnncGlobalStatic._clientGeneralId		= a['ID_CLIENT_GENERAL'];
			gnncGlobalStatic._userAdmin				= int(a['IS_ADMIN']) === 1 ? true : false ;
			gnncGlobalStatic._userClient			= int(a['IS_CLIENT']) === 1 ? true : false ;
			gnncGlobalStatic._userId				= a['ID'];
			gnncGlobalStatic._userIdClient			= a['ID_CLIENT'];
			gnncGlobalStatic._userNameClient		= a['NICK_NAME'] ? a['NICK_NAME'] : a['NAME'];
			gnncGlobalStatic._userNameLogin			= a['USER'];
			gnncGlobalStatic._userEmail				= a['EMAIL'];
			gnncGlobalStatic._userBirthday			= a['DATE_BIRTH'];
			gnncGlobalStatic._userIdGroupPermission	= a['ID_GROUP'];//ID_GROUP_PERMISSION
			
			/*
			var g:gnncGlobalStatic = new gnncGlobalStatic();
			var i:uint;
			var t:Array = gnncDataObject.__getPropertysNamesAMFPhp(_x.DATA_OBJ,'_',true);
			
			for(i=0; i<t.length; i++)
			{
			if(g.hasOwnProperty(t[i]))
			gnncGlobalStatic[t[i]] = t[(i+1)];
			i++;
			}
			*/
			
			_r.call();
		}

		/** 
		 * ####################################
		 * results
		 * ####################################
		 * **/
		protected function __handleResultAmf(event:*=null):void 
		{
			__clearValues();
			
			switch(_m)
			{
				case _METHOD_CONNECT_AMF_GLOBAL:
					
					_rO 	= _x.DATA_OBJ;
					_rA 	= _x.DATA_ARR;
					
					break;
				
				case _METHOD_CONNECT_AMF_PERSONAL:
					
					_rO		= (event.result);
					_rA 	= gnncDataObject.__object2ArrayCollection(_rO);

					break;
				
				default:
					
					__handleFaultnoMethod.call();
					
					return;
			}
			
			//__checkValues(_rA.getItemAt);
			__checkValues(_rO,_rA.length);
		}
		
		protected function __handleResultFile(event:*=null):void 
		{
			__clearValues();
			
			var loader:URLLoader 	= URLLoader(event.target);
			_rS 					= String(loader.data);
			
			//_rO						= new Object(_rS);
			_rA						= new ArrayCollection(gnncData.__toArray(_rS,"\n"));
			
			//__checkValues_rA);
			__checkValues(_rO,0);
		}

		/** 
		 * ####################################
		 * error
		 * ####################################
		 * **/
		protected function __handleFault(event:*=null):void 
		{
			__clearValues();
			
			_error					= true;

			_f.call();
		}
		
		protected function __handleFaultnoMethod():void 
		{
			__handleFault.call(null);
		}

	}
}