package GNNC.sqlTables
{
	import GNNC.data.globals.gnncGlobalStatic;
	
	public class table_course_student
	{
		public var _KEY:String;
		public var _KEY_SQL:String;
		public var _BREAK_SQL:String;
		public var _PROGRAMNAME:String;
		public var _PROGRAMID:uint;
		public var _PROGRAMVERSION:String;
		public var _CLIENTIDGENERAL:uint;
		public var _USERIDGENERAL:uint;
		public var _DATABASE:String;

		public var _TABLE:String 				= 'COURSE_STUDENT';
		
		public var ID:uint;
		public var ID_CLIENT:uint;
		public var ID_PROJECT:uint;
		public var ACTIVE:uint; // 0 --> Indefinido 1--> Matriculado 2--> Desistência
		
		public var DATE_OUT:String = '';
		public var MOTIVE_OUT:String = '';
		
		public function table_course_student(ID_:uint=0)
		{
			ID = ID_;
			table_info();
		}
		
		public function table_info():void
		{
			if(_TABLE)
			{
				_KEY						= gnncGlobalStatic._keyClient;
				_KEY_SQL					= gnncGlobalStatic._keySql;
				_BREAK_SQL					= gnncGlobalStatic._breakSql;

				_PROGRAMNAME				= gnncGlobalStatic._programName;
				_PROGRAMID					= gnncGlobalStatic._programId; _PROGRAMVERSION = gnncGlobalStatic._programVersion;
				_CLIENTIDGENERAL			= gnncGlobalStatic._clientGeneralId;
				_USERIDGENERAL				= gnncGlobalStatic._userId;
				_DATABASE					= gnncGlobalStatic._dataBase;
			}
		}
	}
}