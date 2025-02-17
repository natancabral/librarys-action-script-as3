package be.boulevart.as3.security { 
	import be.boulevart.as3.security.Rijndael;
	
	public class Encryption
	{
		protected var encryptionType:Object;
		protected var input:String;
		protected var key:String;
		protected var mode:String;
		protected var keySize:Number;
		protected var blockSize:Number;
		protected var isBase8orBase64:Boolean = false;
		protected var isTEAorRC4:Boolean = false;
		//protected var isGUID:Boolean = false;
		protected var isGoauldorMD5orROT13orSHA1:Boolean = false;
		protected var isRijndael:Boolean = false;
		protected var isLZW:Boolean = false;
		protected var r:Rijndael;
		
		public function Encryption(type:Object, input:String, key:String, mode:String, keySize:Number, blockSize:Number)
		{
			if (type != null) this.setEncryptionType(type);
			if (input != null) this.setInput(input);
			if (key != null) this.setKey(key);
			if (mode != null) this.setMode(mode);
			
			switch(type)
			{
				case be.boulevart.as3.security.Base8:
					this.isBase8orBase64 = true; break;
				case be.boulevart.as3.security.Base64: 
					this.isBase8orBase64 = true; break;
				case be.boulevart.as3.security.SHA1:
					this.isGoauldorMD5orROT13orSHA1 = true; break;
				case be.boulevart.as3.security.MD5:
					this.isGoauldorMD5orROT13orSHA1 = true; break;
				case be.boulevart.as3.security.RC4:
					this.isTEAorRC4 = true; break;
				case be.boulevart.as3.security.TEA:
					this.isTEAorRC4 = true; break;
				//case be.boulevart.as3.security.GUID:
					//this.isGUID = true; break;
				case be.boulevart.as3.security.LZW:
					this.isLZW = true; break;
				case be.boulevart.as3.security.ROT13:
					this.isGoauldorMD5orROT13orSHA1 = true; break;
				case be.boulevart.as3.security.Goauld:
					this.isGoauldorMD5orROT13orSHA1 = true; break;
				case be.boulevart.as3.security.Rijndael:
					this.isRijndael = true;
					if ((this.keySize != false) && (this.blockSize != false)){
						r = new Rijndael(keySize, blockSize);
					}else if(this.keySize != false){
						r = new Rijndael(keySize, null);
					}else if(this.blockSize != false){
						r = new Rijndael(null, blockSize);
					}else{
						r = new Rijndael(null, null);
					}
					break;
			}
		}
		
		/* Functie	: calculate()
		*  Doel		: genereren van een checksum string
		*  Kan met	: Goauld, MD5, ROT13, SHA1
		* */
		public function calculate():void
		{
			if(!isGoauldorMD5orROT13orSHA1)
			{
				throw new Error("Deze functie is ongeldig voor het gekozen encryptietype!  Functie 'calculate' kan enkel aangeroepen worden voor het berekenen van een MD5, SHA1, ROT13 of Goauld string.");
			}
			
			if(this.getInput().length <= 0)
			{
				throw new Error("Input string bestaat niet");
			}
			else
			{
				this.setInput(this.getEncryptionType().calculate(this.getInput()));
			}
		}
		
		
		/* Functie	: create()
		*  Doel		: genereren van een unieke GUID string
		*  Kan met	: GUID
		* */
		/*public function create():void
		{
			if(!isGUID)
			{
				throw new Error("Deze functie is ongeldig voor het gekozen encryptietype!  Functie 'create' kan enkel aangeroepen worden voor het berekenen van een unieke GUID string.");
			}
			
			this.setInput(this.getEncryptionType().create());
		}*/
		
		
		/* Functie	: compress()
		*  Doel		: comprimeren van een string met het LZW-algoritme
		*  Kan met	: LZW
		* */
		public function compress():void
		{
			if(!isLZW)
			{
				throw new Error("Deze functie is ongeldig voor het gekozen encryptietype!  Functie 'compress' kan enkel aangeroepen worden voor het comprimeren van een string via LZW.");
			}
			
			if(this.getInput().length <= 0)
			{
				throw new Error("Input string bestaat niet");
			}
			else
			{
				this.setInput(this.getEncryptionType().compress(this.getInput()));
			}
		}
		
		
		/* Functie	: decompress()
		*  Doel		: decomprimeren van een string met het LZW-algoritme
		*  Kan met	: LZW
		* */
		public function decompress():void
		{
			if(!isLZW)
			{
				throw new Error("Deze functie is ongeldig voor het gekozen encryptietype!  Functie 'decompress' kan enkel aangeroepen worden voor het decomprimeren van een string via LZW.");
			}
			
			if(this.getInput().length <= 0)
			{
				throw new Error("Input string bestaat niet");
			}
			else
			{
				this.setInput(this.getEncryptionType().decompress(this.getInput()));
			}
		}
		
		
		/* Functie	: encode()
		*  Doel		: encrypteren van een string met Base8 of Base64
		*  Kan met	: Base8, Base64
		* */
		public function encode():void
		{
			if(!isBase8orBase64)
			{
				throw new Error("Deze functie is ongeldig voor het gekozen encryptietype!  Functie 'encode' kan enkel aangeroepen worden voor een Base8 of Base64 encryptie.");
			}
			
			if(this.getInput().length <= 0)
			{
				throw new Error("Input string bestaat niet");
			}
			else
			{
				this.setInput(this.getEncryptionType().encode(this.getInput()));
			}
		}
		
		
		/* Functie	: decode()
		*  Doel		: decrypteren van een string die met Base8 of Base64 werd gecodeerd
		*  Kan met	: Base8, Base64
		* */
		public function decode():void
		{
			if(!isBase8orBase64)
			{
				throw new Error("Deze functie is ongeldig voor het gekozen encryptietype!  Functie 'decode' kan enkel aangeroepen worden voor een Base8 of Base64 decryptie.");
			}
			
			if(this.getInput().length <= 0)
			{
				throw new Error("Input string bestaat niet");
			}
			else
			{
				this.setInput(this.getEncryptionType().decode(this.getInput()));
			}
		}
		
		
		/* Functie	: encrypt()
		*  Doel		: encrypteren van een string met een key om het algoritme te berekenen
		*  Kan met	: TEA, RC4
		* */
		public function encrypt():void
		{
			if(!isTEAorRC4)
			{
				throw new Error("Deze functie is ongeldig voor het gekozen encryptietype!  Functie 'encrypt' kan enkel aangeroepen worden voor een TEA of RC4 encryptie.");
			}
			
			if((this.getInput().length > 0) && (this.getKey().length > 0))
			{
				this.setInput(this.getEncryptionType().encrypt(this.getInput(), this.getKey()));
			}
			else if (this.getInput().length <= 0)
			{
				throw new Error("Input string bestaat niet");
			}
			else if (this.getKey().length <= 0)
			{
				throw new Error("Geen key opgegeven voor de encryptie");
			}
		}
		
		
		/* Functie	: decrypt()
		*  Doel		: decrypteren van een string met een key om het algoritme te berekenen
		*  Kan met	: TEA, RC4
		* */
		public function decrypt():void
		{
			if(!isTEAorRC4)
			{
				throw new Error("Deze functie is ongeldig voor het gekozen encryptietype!  Functie 'decrypt' kan enkel aangeroepen worden voor een TEA of RC4 encryptie.");
			}
			
			if((this.getInput().length > 0) && (this.getKey().length > 0))
			{
				this.setInput(this.getEncryptionType().decrypt(this.getInput(), this.getKey()));
			}
			else if (this.getInput().length <= 0)
			{
				throw new Error("Input string bestaat niet");
			}
			else if (this.getKey().length <= 0)
			{
				throw new Error("Geen key opgegeven voor de encryptie");
			}
		}
		
		
		/* Functie	: encryptRijndael()
		*  Doel		: encrypteren van een string met een key om het algoritme te berekenen
		*  Kan met	: Rijndael
		* */
		public function encryptRijndael():void
		{
			if(!isRijndael)
			{
				throw new Error("Deze functie is ongeldig voor het gekozen encryptietype!  Functie 'encryptRijndael' kan enkel aangeroepen worden voor een Rijndael encryptie.");
			}
			
			if((this.getInput().length > 0) && (this.getKey().length > 0) && (this.getMode().length > 0))
			{
				this.setInput(r.encrypt(this.getInput(), this.getKey(), this.getMode()));
			}
			else if (this.getInput().length <= 0)
			{
				throw new Error("Input string bestaat niet");
			}
			else if (this.getKey().length <= 0)
			{
				throw new Error("Geen key opgegeven voor de encryptie");
			}
			else if (this.getMode().length <= 0)
			{
				throw new Error("Geen modus opgegeven voor Rijndael encryptie.  Geldige modi zijn CBC en ECB.");
			}
		}
		
		
		/* Functie	: decryptRijndael()
		*  Doel		: decrypteren van een string met een key om het algoritme te berekenen
		*  Kan met	: Rijndael
		* */
		public function decryptRijndael():void
		{
			if(!isRijndael)
			{
				throw new Error("Deze functie is ongeldig voor het gekozen encryptietype!  Functie 'decryptRijndael' kan enkel aangeroepen worden voor een Rijndael decryptie.");
			}
			
			if((this.getInput().length > 0) && (this.getKey().length > 0) && (this.getMode().length > 0))
			{
				this.setInput(r.decrypt(this.getInput(), this.getKey(), this.getMode()));
			}
			else if (this.getInput().length <= 0)
			{
				throw new Error("Input string bestaat niet");
			}
			else if (this.getKey().length <= 0)
			{
				throw new Error("Geen key opgegeven voor de decryptie");
			}
			else if (this.getMode().length <= 0)
			{
				throw new Error("Geen modus opgegeven voor Rijndael decryptie.  Geldige modi zijn CBC en ECB.");
			}
		}
		
		
		// Public getters & setters
		public function getInput():String
		{
			return input;
		}
		
		
		// Private getters & setters
		protected function setEncryptionType(et:Object):void
		{
			encryptionType = et;
		}
		
		protected function getEncryptionType():Object
		{
			return encryptionType;
		}
		
		protected function setInput(str:String):void
		{
			input = str;
		}
		
		protected function getKey():String
		{
			return key;
		}
		
		protected function setKey(str:String):void
		{
			key = str;
		}
		
		protected function getMode():String
		{
			return mode;
		}
		
		protected function setMode(str:String):void
		{
			mode = str;
		}
	}
	
}