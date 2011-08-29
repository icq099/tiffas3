package format.swf
{
	import flash.utils.ByteArray;
	
	public class OpCodes extends ABCFileStructs
	{
		public static const OP_bkpt:int = 0x01
		public static const OP_nop:int = 0x02
		public static const OP_throw:int = 0x03
		public static const OP_getsuper:int = 0x04
		public static const OP_setsuper:int = 0x05
		public static const OP_dxns:int = 0x06
		public static const OP_dxnslate:int = 0x07
		public static const OP_kill:int = 0x08
		public static const OP_label:int = 0x09
		public static const OP_ifnlt:int = 0x0C
		public static const OP_ifnle:int = 0x0D
		public static const OP_ifngt:int = 0x0E
		public static const OP_ifnge:int = 0x0F
		public static const OP_jump:int = 0x10
		public static const OP_iftrue:int = 0x11
		public static const OP_iffalse:int = 0x12
		public static const OP_ifeq:int = 0x13
		public static const OP_ifne:int = 0x14
		public static const OP_iflt:int = 0x15
		public static const OP_ifle:int = 0x16
		public static const OP_ifgt:int = 0x17
		public static const OP_ifge:int = 0x18
		public static const OP_ifstricteq:int = 0x19
		public static const OP_ifstrictne:int = 0x1A
		public static const OP_lookupswitch:int = 0x1B
		public static const OP_pushwith:int = 0x1C
		public static const OP_popscope:int = 0x1D
		public static const OP_nextname:int = 0x1E
		public static const OP_hasnext:int = 0x1F
		public static const OP_pushnull:int = 0x20
		public static const OP_pushundefined:int = 0x21
		public static const OP_pushconstant:int = 0x22
		public static const OP_nextvalue:int = 0x23
		public static const OP_pushbyte:int = 0x24
		public static const OP_pushshort:int = 0x25
		public static const OP_pushtrue:int = 0x26
		public static const OP_pushfalse:int = 0x27
		public static const OP_pushnan:int = 0x28
		public static const OP_pop:int = 0x29
		public static const OP_dup:int = 0x2A
		public static const OP_swap:int = 0x2B
		public static const OP_pushstring:int = 0x2C
		public static const OP_pushint:int = 0x2D
		public static const OP_pushuint:int = 0x2E
		public static const OP_pushdouble:int = 0x2F
		public static const OP_pushscope:int = 0x30
		public static const OP_pushnamespace:int = 0x31
		public static const OP_hasnext2:int = 0x32
		public static const OP_newfunction:int = 0x40
		public static const OP_call:int = 0x41
		public static const OP_construct:int = 0x42
		public static const OP_callmethod:int = 0x43
		public static const OP_callstatic:int = 0x44
		public static const OP_callsuper:int = 0x45
		public static const OP_callproperty:int = 0x46
		public static const OP_returnvoid:int = 0x47
		public static const OP_returnvalue:int = 0x48
		public static const OP_constructsuper:int = 0x49
		public static const OP_constructprop:int = 0x4A
		public static const OP_callsuperid:int = 0x4B
		public static const OP_callproplex:int = 0x4C
		public static const OP_callinterface:int = 0x4D
		public static const OP_callsupervoid:int = 0x4E
		public static const OP_callpropvoid:int = 0x4F
		public static const OP_newobject:int = 0x55
		public static const OP_newarray:int = 0x56
		public static const OP_newactivation:int = 0x57
		public static const OP_newclass:int = 0x58
		public static const OP_getdescendants:int = 0x59
		public static const OP_newcatch:int = 0x5A
		public static const OP_findpropstrict:int = 0x5D
		public static const OP_findproperty:int = 0x5E
		public static const OP_finddef:int = 0x5F
		public static const OP_getlex:int = 0x60
		public static const OP_setproperty:int = 0x61
		public static const OP_getlocal:int = 0x62
		public static const OP_setlocal:int = 0x63
		public static const OP_getglobalscope:int = 0x64
		public static const OP_getscopeobject:int = 0x65
		public static const OP_getproperty:int = 0x66
		public static const OP_getpropertylate:int = 0x67
		public static const OP_initproperty:int = 0x68
		public static const OP_setpropertylate:int = 0x69
		public static const OP_deleteproperty:int = 0x6A
		public static const OP_deletepropertylate:int = 0x6B
		public static const OP_getslot:int = 0x6C
		public static const OP_setslot:int = 0x6D
		public static const OP_getglobalslot:int = 0x6E
		public static const OP_setglobalslot:int = 0x6F
		public static const OP_convert_s:int = 0x70
		public static const OP_esc_xelem:int = 0x71
		public static const OP_esc_xattr:int = 0x72
		public static const OP_convert_i:int = 0x73
		public static const OP_convert_u:int = 0x74
		public static const OP_convert_d:int = 0x75
		public static const OP_convert_b:int = 0x76
		public static const OP_convert_o:int = 0x77
		public static const OP_coerce:int = 0x80
		public static const OP_coerce_b:int = 0x81
		public static const OP_coerce_a:int = 0x82
		public static const OP_coerce_i:int = 0x83
		public static const OP_coerce_d:int = 0x84
		public static const OP_coerce_s:int = 0x85
		public static const OP_astype:int = 0x86
		public static const OP_astypelate:int = 0x87
		public static const OP_coerce_u:int = 0x88
		public static const OP_coerce_o:int = 0x89
		public static const OP_negate:int = 0x90
		public static const OP_increment:int = 0x91
		public static const OP_inclocal:int = 0x92
		public static const OP_decrement:int = 0x93
		public static const OP_declocal:int = 0x94
		public static const OP_typeof:int = 0x95
		public static const OP_not:int = 0x96
		public static const OP_bitnot:int = 0x97
		public static const OP_concat:int = 0x9A
		public static const OP_add_d:int = 0x9B
		public static const OP_add:int = 0xA0
		public static const OP_subtract:int = 0xA1
		public static const OP_multiply:int = 0xA2
		public static const OP_divide:int = 0xA3
		public static const OP_modulo:int = 0xA4
		public static const OP_lshift:int = 0xA5
		public static const OP_rshift:int = 0xA6
		public static const OP_urshift:int = 0xA7
		public static const OP_bitand:int = 0xA8
		public static const OP_bitor:int = 0xA9
		public static const OP_bitxor:int = 0xAA
		public static const OP_equals:int = 0xAB
		public static const OP_strictequals:int = 0xAC
		public static const OP_lessthan:int = 0xAD
		public static const OP_lessequals:int = 0xAE
		public static const OP_greaterthan:int = 0xAF
		public static const OP_greaterequals:int = 0xB0
		public static const OP_instanceof:int = 0xB1
		public static const OP_istype:int = 0xB2
		public static const OP_istypelate:int = 0xB3
		public static const OP_in:int = 0xB4
		public static const OP_increment_i:int = 0xC0
		public static const OP_decrement_i:int = 0xC1
		public static const OP_inclocal_i:int = 0xC2
		public static const OP_declocal_i:int = 0xC3
		public static const OP_negate_i:int = 0xC4
		public static const OP_add_i:int = 0xC5
		public static const OP_subtract_i:int = 0xC6
		public static const OP_multiply_i:int = 0xC7
		public static const OP_getlocal0:int = 0xD0
		public static const OP_getlocal1:int = 0xD1
		public static const OP_getlocal2:int = 0xD2
		public static const OP_getlocal3:int = 0xD3
		public static const OP_setlocal0:int = 0xD4
		public static const OP_setlocal1:int = 0xD5
		public static const OP_setlocal2:int = 0xD6
		public static const OP_setlocal3:int = 0xD7
		public static const OP_debug:int = 0xEF
		public static const OP_debugline:int = 0xF0
		public static const OP_debugfile:int = 0xF1
		public static const OP_bkptline:int = 0xF2
		
		public static const opNames:Array = [
			"OP_0x00       ",
			"bkpt          ",
			"nop           ",
			"throw         ",
			"getsuper      ",
			"setsuper      ",
			"dxns          ",
			"dxnslate      ",
			"kill          ",
			"label         ",
			"OP_0x0A       ",
			"OP_0x0B       ",
			"ifnlt         ",
			"ifnle         ",
			"ifngt         ",
			"ifnge         ",
			"jump          ",
			"iftrue        ",
			"iffalse       ",
			"ifeq          ",
			"ifne          ",
			"iflt          ",
			"ifle          ",
			"ifgt          ",
			"ifge          ",
			"ifstricteq    ",
			"ifstrictne    ",
			"lookupswitch  ",
			"pushwith      ",
			"popscope      ",
			"nextname      ",
			"hasnext       ",
			"pushnull      ",
			"pushundefined ",
			"pushconstant  ",
			"nextvalue     ",
			"pushbyte      ",
			"pushshort     ",
			"pushtrue      ",
			"pushfalse     ",
			"pushnan       ",
			"pop           ",
			"dup           ",
			"swap          ",
			"pushstring    ",
			"pushint       ",
			"pushuint      ",
			"pushdouble    ",
			"pushscope     ",
			"pushnamespace ",
			"hasnext2      ",
			"OP_0x33       ",
			"OP_0x34       ",
			"OP_0x35       ",
			"OP_0x36       ",
			"OP_0x37       ",
			"OP_0x38       ",
			"OP_0x39       ",
			"OP_0x3A       ",
			"OP_0x3B       ",
			"OP_0x3C       ",
			"OP_0x3D       ",
			"OP_0x3E       ",
			"OP_0x3F       ",
			"newfunction   ",
			"call          ",
			"construct     ",
			"callmethod    ",
			"callstatic    ",
			"callsuper     ",
			"callproperty  ",
			"returnvoid    ",
			"returnvalue   ",
			"constructsuper",
			"constructprop ",
			"callsuperid   ",
			"callproplex   ",
			"callinterface ",
			"callsupervoid ",
			"callpropvoid  ",
			"OP_0x50       ",
			"OP_0x51       ",
			"OP_0x52       ",
			"OP_0x53       ",
			"OP_0x54       ",
			"newobject     ",
			"newarray      ",
			"newactivation ",
			"newclass      ",
			"getdescendants",
			"newcatch      ",
			"OP_0x5B       ",
			"OP_0x5C       ",
			"findpropstrict",
			"findproperty  ",
			"finddef       ",
			"getlex        ",
			"setproperty   ",
			"getlocal      ",
			"setlocal      ",
			"getglobalscope",
			"getscopeobject",
			"getproperty   ",
			"OP_0x67       ",
			"initproperty  ",
			"OP_0x69       ",
			"deleteproperty",
			"OP_0x6A       ",
			"getslot       ",
			"setslot       ",
			"getglobalslot ",
			"setglobalslot ",
			"convert_s     ",
			"esc_xelem     ",
			"esc_xattr     ",
			"convert_i     ",
			"convert_u     ",
			"convert_d     ",
			"convert_b     ",
			"convert_o     ",
			"checkfilter   ",
			"OP_0x79       ",
			"OP_0x7A       ",
			"OP_0x7B       ",
			"OP_0x7C       ",
			"OP_0x7D       ",
			"OP_0x7E       ",
			"OP_0x7F       ",
			"coerce        ",
			"coerce_b      ",
			"coerce_a      ",
			"coerce_i      ",
			"coerce_d      ",
			"coerce_s      ",
			"astype        ",
			"astypelate    ",
			"coerce_u      ",
			"coerce_o      ",
			"OP_0x8A       ",
			"OP_0x8B       ",
			"OP_0x8C       ",
			"OP_0x8D       ",
			"OP_0x8E       ",
			"OP_0x8F       ",
			"negate        ",
			"increment     ",
			"inclocal      ",
			"decrement     ",
			"declocal      ",
			"typeof        ",
			"not           ",
			"bitnot        ",
			"OP_0x98       ",
			"OP_0x99       ",
			"concat        ",
			"add_d         ",
			"OP_0x9C       ",
			"OP_0x9D       ",
			"OP_0x9E       ",
			"OP_0x9F       ",
			"add           ",
			"subtract      ",
			"multiply      ",
			"divide        ",
			"modulo        ",
			"lshift        ",
			"rshift        ",
			"urshift       ",
			"bitand        ",
			"bitor         ",
			"bitxor        ",
			"equals        ",
			"strictequals  ",
			"lessthan      ",
			"lessequals    ",
			"greaterthan   ",
			"greaterequals ",
			"instanceof    ",
			"istype        ",
			"istypelate    ",
			"in            ",
			"OP_0xB5       ",
			"OP_0xB6       ",
			"OP_0xB7       ",
			"OP_0xB8       ",
			"OP_0xB9       ",
			"OP_0xBA       ",
			"OP_0xBB       ",
			"OP_0xBC       ",
			"OP_0xBD       ",
			"OP_0xBE       ",
			"OP_0xBF       ",
			"increment_i   ",
			"decrement_i   ",
			"inclocal_i    ",
			"declocal_i    ",
			"negate_i      ",
			"add_i         ",
			"subtract_i    ",
			"multiply_i    ",
			"OP_0xC8       ",
			"OP_0xC9       ",
			"OP_0xCA       ",
			"OP_0xCB       ",
			"OP_0xCC       ",
			"OP_0xCD       ",
			"OP_0xCE       ",
			"OP_0xCF       ",
			"getlocal0     ",
			"getlocal1     ",
			"getlocal2     ",
			"getlocal3     ",
			"setlocal0     ",
			"setlocal1     ",
			"setlocal2     ",
			"setlocal3     ",
			"OP_0xD8       ",
			"OP_0xD9       ",
			"OP_0xDA       ",
			"OP_0xDB       ",
			"OP_0xDC       ",
			"OP_0xDD       ",
			"OP_0xDE       ",
			"OP_0xDF       ",
			"OP_0xE0       ",
			"OP_0xE1       ",
			"OP_0xE2       ",
			"OP_0xE3       ",
			"OP_0xE4       ",
			"OP_0xE5       ",
			"OP_0xE6       ",
			"OP_0xE7       ",
			"OP_0xE8       ",
			"OP_0xE9       ",
			"OP_0xEA       ",
			"OP_0xEB       ",
			"OP_0xEC       ",
			"OP_0xED       ",
			"OP_0xEE       ",
			"debug         ",
			"debugline     ",
			"debugfile     ",
			"bkptline      ",
			"timestamp     ",
			"OP_0xF4       ",
			"verifypass    ",
			"alloc         ",
			"mark          ",
			"wb            ",
			"prologue      ",
			"sendenter     ",
			"doubletoatom  ",
			"sweep         ",
			"codegenop     ",
			"verifyop      ",
			"decode        "
		];
		
		public var usedStrings:Array = [];
		public var usedPropertyMultiNames:Array = [];
		public var opCount:int = 0;
		
		public function OpCodes(byte:ByteArray)
		{
			super(byte);
		}
		
		override protected function read():void
		{
			byte.position = 0;
			var opcode:int;
			var t:int;
			while(byte.bytesAvailable > 0)
			{
				opcode = byte.readUnsignedByte();
				switch(opcode)
				{
					case OP_debugfile:
						readVariableLengthUnsigned32();
						break;
					case OP_pushstring:
						//					s += '"' + abc.strings[readU32()].replace(/\n/g,"\\n").replace(/\t/g,"\\t") + '"'
						usedStrings.push(readVariableLengthUnsigned32());
						break;
					case OP_pushnamespace:
						//					s += abc.namespaces[readU32()]
						readVariableLengthUnsigned32();
						break
					case OP_pushint:
						//					var i:int = abc.ints[readU32()]
						//					s += i + "\t// 0x" + i.toString(16)
						readVariableLengthUnsigned32();
						break
					case OP_pushuint:
						//					var u:uint = abc.uints[readU32()]
						//					s += u + "\t// 0x" + u.toString(16)
						readVariableLengthUnsigned32();
						break;
					case OP_pushdouble:
						//					s += abc.doubles[readU32()]
						readVariableLengthUnsigned32();
						break;
					case OP_getsuper: 
					case OP_setsuper: 
					case OP_initproperty: 
					case OP_getlex: 
					case OP_findpropstrict: 
					case OP_findproperty:
					case OP_finddef:
					case OP_deleteproperty: 
					case OP_istype: 
					case OP_coerce: 
					case OP_astype: 
					case OP_getdescendants:
						//					s += abc.names[readU32()]
						readVariableLengthUnsigned32();
						break;
					case OP_getproperty: 
					case OP_setproperty:
						usedPropertyMultiNames.push(readVariableLengthUnsigned32());
						break;
					case OP_constructprop:
					case OP_callproperty:
					case OP_callproplex:
					case OP_callsuper:
					case OP_callsupervoid:
					case OP_callpropvoid:
						//					s += abc.names[readU32()]
						//					s += " (" + readU32() + ")"
						readVariableLengthUnsigned32();
						readVariableLengthUnsigned32();
						break;
					case OP_newfunction:
						//					var method_id = readU32()
						//					s += abc.methods[method_id]
						//					abc.methods[method_id].anon = true
						readVariableLengthUnsigned32();
						break;
					case OP_callstatic:
						//					s += abc.methods[readU32()]
						//					s += " (" + readU32() + ")"
						readVariableLengthUnsigned32();
						readVariableLengthUnsigned32();
						break;
					case OP_newclass: 
						//					s += abc.instances[readU32()]
						readVariableLengthUnsigned32();
						break;
					case OP_lookupswitch:
						//					var pos = code.position-1;
						//					var target = pos + readS24()
						//					var maxindex = readU32()
						//					s += "default:" + labels.labelFor(target) // target + "("+(target-pos)+")"
						//					s += " maxcase:" + maxindex
						//					for (var i:int=0; i <= maxindex; i++) {
						//						target = pos + readS24();
						//						s += " " + labels.labelFor(target) // target + "("+(target-pos)+")"
						//					}
						readS24();
						var maxindex:int = readVariableLengthUnsigned32();
						for (var i:int = 0; i <= maxindex; i++) 
						{
							readS24();
						}
						break;
					case OP_jump:
					case OP_iftrue:		case OP_iffalse:
					case OP_ifeq:		case OP_ifne:
					case OP_ifge:		case OP_ifnge:
					case OP_ifgt:		case OP_ifngt:
					case OP_ifle:		case OP_ifnle:
					case OP_iflt:		case OP_ifnlt:
					case OP_ifstricteq:	case OP_ifstrictne:
						//					var offset = readS24()
						//					var target = code.position+offset
						//					//s += target + " ("+offset+")"
						//					s += labels.labelFor(target)
						//					if (!((code.position) in labels))
						//						s += "\n"
						readS24();
						break;
					case OP_inclocal:
					case OP_declocal:
					case OP_inclocal_i:
					case OP_declocal_i:
					case OP_getlocal:
					case OP_kill:
					case OP_setlocal:
					case OP_debugline:
					case OP_getglobalslot:
					case OP_getslot:
					case OP_setglobalslot:
					case OP_setslot:
					case OP_pushshort:
					case OP_newcatch:
						//					s += readU32()
						readVariableLengthUnsigned32();
						break
					case OP_debug:
						//					s += code.readUnsignedByte() 
						//					s += " " + readU32()
						//					s += " " + code.readUnsignedByte()
						//					s += " " + readU32()
						byte.readUnsignedByte();
						readVariableLengthUnsigned32();
						byte.readUnsignedByte();
						readVariableLengthUnsigned32();
						break;
					case OP_newobject:
						//					s += "{" + readU32() + "}"
						readVariableLengthUnsigned32();
						break;
					case OP_newarray:
						//					s += "[" + readU32() + "]"
						readVariableLengthUnsigned32();
						break;
					case OP_call:
					case OP_construct:
					case OP_constructsuper:
						//					s += "(" + readU32() + ")"
						readVariableLengthUnsigned32();
						break;
					case OP_pushbyte:
					case OP_getscopeobject:
						//					s += code.readByte()
						byte.readByte();
						break;
					case OP_hasnext2:
						//					s += readU32() + " " + readU32()
						readVariableLengthUnsigned32();
						readVariableLengthUnsigned32();
					default:
						/*if (opNames[opcode] == ("0x"+opcode.toString(16).toUpperCase()))
						s += " UNKNOWN OPCODE"*/
						break
				}
			}
		}
	}
}