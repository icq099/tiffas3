package tiff
{
	import flash.utils.ByteArray;
	
	
/*
 * NB: In the comments below,
 *  - items marked with a + are obsoleted by revision 5.0,
 *  - items marked with a ! are introduced in revision 6.0.
 *  - items marked with a % are introduced post revision 6.0.
 *  - items marked with a $ are obsoleted by revision 6.0.
 */


/*
 * TIFF Tag Definitions.
 */

	public class Tag
	{
		public var id:int;
		
		public static const MINIMUM:int             =254;
		public static const MAXIMUM_STANDARD:int	=532;
		public static const MINIMUM_PRIVATE:int 	=32768;
		
		public static const SUBFILETYPE:int			=254;	/* subfile data descriptor */
		public static const OSUBFILETYPE:int		=255;	/* +kind of data in subfile */
		public static const IMAGEWIDTH:int			=256;	/* image width in pixels */
		public static const IMAGELENGTH:int			=257;	/* image height in pixels */
		public static const BITSPERSAMPLE:int		=258;	/* bits per channel (sample) */
		public static const COMPRESSION:int			=259;	/* data compression technique */
		/* 260 & 261 are undefined */
		public static const PHOTOMETRIC:int			=262;	/* photometric interpretation */
		public static const THRESHHOLDING:int		=263;	/* +thresholding used on data */
		public static const CELLWIDTH:int			=264;	/* +dithering matrix width */
		public static const CELLLENGTH:int			=265;	/* +dithering matrix height */
		public static const FILLORDER:int			=266;	/* data order within a byte */
		/* 267 & 268 are undefined */
		public static const DOCUMENTNAME:int		=269;	/* name of doc. image is from */
		public static const IMAGEDESCRIPTION:int	=270;	/* info about image */
		public static const MAKE:int				=271;	/* scanner manufacturer name */
		public static const MODEL:int				=272;	/* scanner model name/number */
		public static const STRIPOFFSETS:int		=273;	/* offsets to data strips */
		public static const ORIENTATION:int			=274;	/* +image orientation */
		/* 275 & 276 are undefined */
		public static const SAMPLESPERPIXEL:int		=277;	/* samples per pixel */
		public static const ROWSPERSTRIP:int		=278;	/* rows per strip of data */
		public static const STRIPBYTECOUNTS:int		=279;	/* bytes counts for strips */
		public static const MINSAMPLEVALUE:int		=280;	/* +minimum sample value */
		public static const MAXSAMPLEVALUE:int		=281;	/* +maximum sample value */
		public static const XRESOLUTION:int			=282;	/* pixels/resolution in x */
		public static const YRESOLUTION:int			=283;	/* pixels/resolution in y */
		public static const PLANARCONFIG:int		=284;	/* storage organization */
		public static const PAGENAME:int			=285;	/* page name image is from */
		public static const XPOSITION:int			=286;	/* x page offset of image lhs */
		public static const YPOSITION:int			=287;	/* y page offset of image lhs */
		public static const FREEOFFSETS:int			=288;	/* +byte offset to free block */
		public static const FREEBYTECOUNTS:int		=289;	/* +sizes of free blocks */
		public static const GRAYRESPONSEUNIT:int	=290;	/* $gray scale curve accuracy */
		public static const GRAYRESPONSECURVE:int	=291;	/* $gray scale response curve */
		public static const GROUP3OPTIONS:int		=292;	/* 32 flag bits */
		public static const GROUP4OPTIONS:int		=293;	/* 32 flag bits */
		/* 294 & 295 are undefined */
		public static const RESOLUTIONUNIT:int		=296;	/* units of resolutions */
		public static const PAGENUMBER:int			=297;	/* page numbers of multi-page */
		/* 298 & 299 are undefined */
		public static const COLORRESPONSEUNIT:int	=300;	/* $color curve accuracy */
		public static const TRANSFERFUNCTION:int	=301;	/* !colorimetry info */
		/* 302, 303, 304 are undefined */
		public static const SOFTWARE:int			=305;	/* name & release */
		public static const DATETIME:int			=306;	/* creation date and time */
		/* 307 - 314 are undefined */
		public static const ARTIST:int				=315;	/* creator of image */
		public static const HOSTCOMPUTER:int		=316;	/* machine where created */
		public static const PREDICTOR:int			=317;	/* prediction scheme w/ LZW */
		public static const WHITEPOINT:int			=318;	/* image white point */
		public static const PRIMARYCHROMATICITIES:int	=319;	/* !primary chromaticities */
		public static const COLORMAP:int			=320;	/* RGB map for pallette image */
		public static const HALFTONEHINTS:int		=321;	/* !highlight+shadow info */
		public static const TILEWIDTH:int			=322;	/* !rows/data tile */
		public static const TILELENGTH:int			=323;	/* !cols/data tile */
		public static const TILEOFFSETS:int			=324;	/* !offsets to data tiles */
		public static const TILEBYTECOUNTS:int		=325;	/* !byte counts for tiles */
		public static const BADFAXLINES:int			=326;	/* lines w/ wrong pixel count */
		public static const	CLEANFAXDATA:int		=327;	/* regenerated line info */
		public static const CONSECUTIVEBADFAXLINES:int	=328;	/* max consecutive bad lines */
		/* 329 is undefined */
		public static const SUBIFD:int				=330;	/* subimage descriptors */
		/* 331 is undefined */
		public static const INKSET:int				=332;	/* !inks in separated image */
		public static const INKNAMES:int			=333;	/* !ascii names of inks */
		public static const NUMBEROFINKS:int		=334;	/* !number of inks */
		public static const DOTRANGE:int			=336;	/* !0% and 100% dot codes */
		public static const TARGETPRINTER:int		=337;	/* !separation target */
		public static const EXTRASAMPLES:int		=338;	/* !info about extra samples */
		public static const SAMPLEFORMAT:int		=339;	/* !data sample format */
		public static const SMINSAMPLEVALUE:int		=340;	/* !variable MinSampleValue */
		public static const SMAXSAMPLEVALUE:int		=341;	/* !variable MaxSampleValue */
		/* 342-346 are undefined */
		public static const JPEGTABLES:int			=347;	/* %JPEG table stream */
			/* 348-511 are undefined */

	/*
 	 * Tags 512-521 are obsoleted by Technical Note #2
   * which specifies a revised JPEG-in-TIFF scheme.
   */
   public static const JPEGPROC:int			=512;	/* !JPEG processing algorithm */
   public static const JPEGIFOFFSET:int		=513;	/* !pointer to SOI marker */
   public static const JPEGIFBYTECOUNT:int		=514;	/* !JFIF stream length */
   public static const JPEGRESTARTINTERVAL:int	=515;	/* !restart interval length */
   /* 316 is undefined */
   public static const JPEGLOSSLESSPREDICTORS:int =517;	/* !lossless proc predictor */
   public static const JPEGPOINTTRANSFORM:int 	=518;	/* !lossless point transform */
   public static const JPEGQTABLES:int			=519;	/* !Q matrice offsets */
   public static const JPEGDCTABLES:int		=520;	/* !DCT table offsets */
   public static const JPEGACTABLES:int		=521;	/* !AC coefficient offsets */
   /* 322-328 are undefined */
   public static const YCBCRCOEFFICIENTS:int	=529;	/* !RGB -> YCbCr transform */
   public static const YCBCRSUBSAMPLING:int	=530;	/* !YCbCr subsampling factors */
   public static const YCBCRPOSITIONING:int	=531;	/* !subsample positioning */
   public static const REFERENCEBLACKWHITE:int	=532;	/* !colorimetry info */
   
   /* tags 32952-32956 are private tags registered to Island Graphics */
   public static const REFPTS:int				=32953;	/* image reference points */
   public static const REGIONTACKPOINT:int		=32954;	/* region-xform tack point */
   public static const REGIONWARPCORNERS:int	=32955;	/* warp quadrilateral */
   public static const REGIONAFFINE:int		=32956;	/* affine transformation mat */
   
   /* tags 32995-32999 are private tags registered to SGI */
   public static const MATTEING:int			=32995;	/* $use ExtraSamples */
   public static const DATATYPE:int			=32996;	/* $use SampleFormat */
   public static const IMAGEDEPTH:int			=32997;	/* z depth of image */
   public static const TILEDEPTH:int			=32998;	/* z depth/data tile */
   
   /* tags 33300-33309 are private tags registered to Pixar */
/*
 * PIXAR_IMAGEFULLWIDTH and PIXAR_IMAGEFULLLENGTH
 * are set when an image has been cropped out of a larger image.  
 * They reflect the size of the original uncropped image.
 * The XPOSITION and YPOSITION can be used
 * to determine the position of the smaller image in the larger one.
 */
 public static const PIXAR_IMAGEFULLWIDTH:int    	=33300;   /* full image size in x */
 public static const PIXAR_IMAGEFULLLENGTH:int   	=33301;   /* full image size in y */
 
 /* tag 33405 is a private tag registered to Eastman Kodak */
 public static const WRITERSERIALNUMBER:int      	=33405;   /* device serial number */
 
 /* tag 33432 is listed in the 6.0 spec w/ unknown ownership */
	public static const COPYRIGHT:int				=33432;	/* copyright string */

/* tag 33881, 33882, and 33884 are private tags registered to Unisys */


	public static const UNISYS_ISIS_IFD:int				=33881;	/* offset to ISIS IFD */
	public static const UNISYS_SIDE:int				    =33882;	/* check side, 1=front 2=back */
	public static const UNISYS_IXPS_IFD:int				=33884;	/* offset to IXPS IFD */

	public static const WEIRD:int				=34975;


/* tag 33881, 33882, and 33884 are private tags registered to Unisys 
33881 - Unisys ISIS Document IFD 
    { 1, "DIN" },
    { 2, "Check Serial Num" },
    { 3, "Processing Date" },
    { 4, "Check Amount" },
    { 5, "Transaction Code" },
    { 6, "Account Number" },
    { 7, "Transit Transit" },
    { 8, "Auxiliary On Us" }, 
    { 9, "Position 44" },
    { 10, "Processing Date" },
    { 11, "User Area" },
        { 0, "User ID" },
        { 1, "Site ID" },
        { 2, "Capture Start" },
        { 3, "Capture PID" },
        { 4, "Document Num" },
        { 5, "Migration Date" },
        { 6, "Micro Film Seq" },
        { 7, "Item Seq" },
        { 8, "Tracer Number" }, 
        { 9, "Side ID" }, //0=front 1=back
        { 10, "Zone List" },
        { 11, "Next Level 1 IFD offset" }, 

33882 - Unisys Side (1=front 2=back)
33884 - Unisys IXPS Document IFD 
    { 1, "Version" },
    { 2, "SIDI" },
    { 10, "Processing Date" },
    { 11, "cdline and amt id" },
    { 12, "Amount" },
    { 101, "DIN" },
    { 102, "Check Serial Number" },
    { 516, "Account Number" },
    { 517, "Aux on Us" },
    { 518, "Position 44" },
    { 519, "Routing and Transit" },
    { 520, "TranCode" },
    { 32000, "IXPS User Area" },
*/

/* 34016-34029 are reserved for ANSI IT8 TIFF/IT <dkelly@etsinc.com) */
	public static const IT8SITE:int				=34016;	/* site name */
	public static const IT8COLORSEQUENCE:int	=34017;	/* color seq. [RGB,CMYK,etc] */
	public static const IT8HEADER:int			=34018;	/* DDES Header */
	public static const IT8RASTERPADDING:int	=34019;	/* raster scanline padding */
	public static const IT8BITSPERRUNLENGTH:int	=34020;	/* # of bits in int run */
	public static const IT8BITSPEREXTENDEDRUNLENGTH:int =34021;/* # of bits in long run */
	public static const IT8COLORTABLE:int		=34022;	/* LW colortable */
	public static const IT8IMAGECOLORINDICATOR:int	=34023;	/* BP/BL image color switch */
	public static const IT8BKGCOLORINDICATOR:int	=34024;	/* BP/BL bg color switch */
	public static const IT8IMAGECOLORVALUE:int	=34025;	/* BP/BL image color value */
	public static const IT8BKGCOLORVALUE:int	=34026;	/* BP/BL bg color value */
	public static const IT8PIXELINTENSITYRANGE:int	=34027;	/* MP pixel intensity value */
	public static const IT8TRANSPARENCYINDICATOR:int =34028;	/* HC transparency switch */
	public static const IT8COLORCHARACTERIZATION:int =34029;	/* color character. table */

/* tags 34232-34236 are private tags registered to Texas Instruments */
	public static const FRAMECOUNT:int          =34232;   /* Sequence Frame Count */

/* tag 34750 is a private tag registered to Adobe? */
	public static const ICCPROFILE:int			=34675;	/* ICC profile data */

/* tag 34750 is a private tag registered to Pixel Magic */
	public static const JBIGOPTIONS:int			=34750;	/* JBIG options */

/* tags 34908-34914 are private tags registered to SGI */
	public static const FAXRECVPARAMS:int		=34908;	/* encoded Class 2 ses. parms */
	public static const FAXSUBADDRESS:int		=34909;	/* received SubAddr string */
	public static const FAXRECVTIME:int			=34910;	/* receive time (secs) */

	
/* tag 65535 is an undefined tag used by Eastman Kodak */
	public static const DCSHUESHIFTVALUES:int   =65535;   /* hue shift correction data */

/*
 * The following are ``pseudo tags'' that can be
 * used to control codec-specific functionality.
 * These tags are not written to file.  Note that
 * these values start at 0xffff+1 so that they'll
 * never collide with Aldus-assigned tags.
 *
 * If you want your private pseudo tags ``registered''
 * (i.e. added to this file), send mail to sam@sgi.com
 * with the appropriate C definitions to add.
 */
	public static const FAXMODE:int				=65536;	/* Group 3/4 format control */
	public static const JPEGQUALITY:int			=65537;	/* Compression quality level */
/* Note: quality level is on the IJG 0-100 scale.  Default value is 75 */
	public static const JPEGCOLORMODE:int		=65538;	/* Auto RGB<=>YCbCr convert? */
	public static const JPEGTABLESMODE:int		=65539;	/* What to put in JPEGTables */
/* Note: default is JPEGTABLESMODE_QUANT | JPEGTABLESMODE_HUFF */
	public static const FAXFILLFUNC:int			=65540;	/* G3/G4 fill function */
	public static const PIXARLOGDATAFMT:int		=65549;	/* PixarLogCodec I/O data sz */

/* 65550-65556 are allocated to Oceana Matrix <dev@oceana.com> */
	public static const DCSIMAGERTYPE:int       =65550;   /* imager model & filter */
	public static const DCSINTERPMODE:int       =65551;   /* interpolation mode */
	public static const DCSBALANCEARRAY:int     =65552;   /* color balance values */
	public static const DCSCORRECTMATRIX:int    =65553;   /* color correction values */
	public static const DCSGAMMA:int            =65554;   /* gamma value */
	public static const DCSTOESHOULDERPTS:int   =65555;   /* toe & shoulder points */
	public static const DCSCALIBRATIONFD:int    =65556;   /* calibration file desc */
/* Note: quality level is on the ZLIB 1-9 scale. Default value is -1 */
	public static const ZIPQUALITY:int			=65557;	/* compression quality level */
	public static const PIXARLOGQUALITY:int		=65558;	/* PixarLog uses same scale */
/* 65559 is allocated to Oceana Matrix <dev@oceana.com> */
	public static const DCSCLIPRECTANGLE:int	=65559;	/* area of image to acquire */
	
	/********************** METHODS ***********************/
		public function Tag(n:int=0) {
		id = n;
		if (!IsStandard()) {
			trace("WARNING: Non-Standard Tag "+n );
		}
		}
	
		public function Value():int {
		return id;
		}
		
		public function IsStandard():Boolean {

		var isValid:Boolean = (id >= MINIMUM && id <= MAXIMUM_STANDARD );
		
		isValid = isValid && (id < 260 || id > 261);
		isValid = isValid && (id < 267 || id > 268);
		isValid = isValid && (id < 275 || id > 276);
		isValid = isValid && (id < 294 || id > 295);
		isValid = isValid && (id < 298 || id > 299);
		isValid = isValid && (id < 302 || id > 304);
		isValid = isValid && (id < 307 || id > 314);
		isValid = isValid && (id != 329 && id != 331);
		isValid = isValid && (id < 342 || id > 346);
		isValid = isValid && (id < 348 || id > 511);
		
		return isValid;
	}
	
		public function IsPrivate():Boolean {
		return (id >= MINIMUM_PRIVATE); 
	}
	
	public function IsOffsetTag():Boolean {
		return ( id==STRIPOFFSETS 
					|| id==TILEOFFSETS 
					|| id==JPEGTABLES
					|| id==JPEGIFOFFSET );
	}

		public function equals(n:int):Boolean{
			return id==n;
		}
	
//	public function write( MotorolaIntelInputFilter out ) throws IOException {
//		out.writeShort(	id ); 
//	}

//	public void read( MemoryFileInputFilter in ) {
//		id = in.readUnsignedShort(); 
//	}

	public function toString():String {
		//return Integer.toString(id); //toHexString(id);
		var sz:String=""; 
	    switch (id) {
	        case SUBFILETYPE               : sz = "SUBFILETYPE      "; break; 
	        case OSUBFILETYPE              : sz = "OSUBFILETYPE     "; break;
	        case IMAGEWIDTH                : sz = "IMAGEWIDTH       "; break;   
	        case IMAGELENGTH               : sz = "IMAGELENGTH      "; break;
	        case BITSPERSAMPLE             : sz = "BITSPERSAMPLE    "; break;   
	        case COMPRESSION               : sz = "COMPRESSION      "; break;
	        case PHOTOMETRIC               : sz = "PHOTOMETRIC      "; break;
	        case THRESHHOLDING             : sz = "THRESHHOLDING    "; break;   
	        case CELLWIDTH                 : sz = "CELLWIDTH        "; break;   
	        case CELLLENGTH                : sz = "CELLLENGTH       "; break;   
	        case FILLORDER                 : sz = "FILLORDER        "; break;
	        case DOCUMENTNAME              : sz = "DOCUMENTNAME     "; break;
	        case IMAGEDESCRIPTION          : sz = "IMAGEDESCRIPTION "; break;
	        case MAKE                      : sz = "MAKE             "; break;
	        case MODEL                     : sz = "MODEL            "; break;   
	        case STRIPOFFSETS              : sz = "STRIPOFFSETS     "; break;
	        case ORIENTATION               : sz = "ORIENTATION      "; break;
	        case SAMPLESPERPIXEL           : sz = "SAMPLESPERPIXEL  "; break;
	        case ROWSPERSTRIP              : sz = "ROWSPERSTRIP     "; break;
	        case STRIPBYTECOUNTS           : sz = "STRIPBYTECOUNTS  "; break;
	        case MINSAMPLEVALUE            : sz = "MINSAMPLEVALUE   "; break;   
	        case MAXSAMPLEVALUE            : sz = "MAXSAMPLEVALUE   "; break;   
	        case XRESOLUTION               : sz = "XRESOLUTION      "; break;
	        case YRESOLUTION               : sz = "YRESOLUTION      "; break;
	        case PLANARCONFIG              : sz = "PLANARCONFIG     "; break;
	        case PAGENAME                  : sz = "PAGENAME         "; break;
	        case XPOSITION                 : sz = "XPOSITION        "; break;   
	        case YPOSITION                 : sz = "YPOSITION        "; break;   
	        case FREEOFFSETS               : sz = "FREEOFFSETS      "; break;
	        case FREEBYTECOUNTS            : sz = "FREEBYTECOUNTS   "; break;   
	        case GRAYRESPONSEUNIT          : sz = "GRAYRESPONSEUNIT "; break;
	        case GRAYRESPONSECURVE         : sz = "GRAYRESPONSECURVE "; break;   
	        case GROUP3OPTIONS             : sz = "GROUP3OPTIONS    "; break;   
	        case GROUP4OPTIONS             : sz = "GROUP4OPTIONS    "; break;   
	        case RESOLUTIONUNIT            : sz = "RESOLUTIONUNIT   "; break;   
	        case PAGENUMBER                : sz = "PAGENUMBER       "; break;   
	        case COLORRESPONSEUNIT         : sz = "COLORRESPONSEUNIT "; break;   
	        case TRANSFERFUNCTION          : sz = "TRANSFERFUNCTION "; break;
	        case SOFTWARE                  : sz = "SOFTWARE         "; break;
	        case DATETIME                  : sz = "DATETIME         "; break;
	        case ARTIST                    : sz = "ARTIST           "; break;   
	        case HOSTCOMPUTER              : sz = "HOSTCOMPUTER     "; break;
	        case PREDICTOR                 : sz = "PREDICTOR        "; break;   
	        case WHITEPOINT                : sz = "WHITEPOINT       "; break;   
	        case PRIMARYCHROMATICITIES     : sz = "PRIMARYCHROMATICITIES "; break; 
	        case COLORMAP                  : sz = "COLORMAP         "; break;
	        case HALFTONEHINTS             : sz = "HALFTONEHINTS    "; break;   
	        case TILEWIDTH                 : sz = "TILEWIDTH        "; break;   
	        case TILELENGTH                : sz = "TILELENGTH       "; break;   
	        case TILEOFFSETS               : sz = "TILEOFFSETS      "; break;
	        case TILEBYTECOUNTS            : sz = "TILEBYTECOUNTS   "; break;   
	        case BADFAXLINES               : sz = "BADFAXLINES      "; break;
	        case CLEANFAXDATA              : sz = "CLEANFAXDATA     "; break;
	        case CONSECUTIVEBADFAXLINES    : sz = "CONSECUTIVEBADFAXLINES "; break;
	        case INKSET                    : sz = "INKSET           "; break;   
	        case INKNAMES                  : sz = "INKNAMES         "; break;
	        case DOTRANGE                  : sz = "DOTRANGE         "; break;
	        case TARGETPRINTER             : sz = "TARGETPRINTER    "; break;   
	        case EXTRASAMPLES              : sz = "EXTRASAMPLES     "; break;
	        case SAMPLEFORMAT              : sz = "SAMPLEFORMAT     "; break;
	        case SMINSAMPLEVALUE           : sz = "SMINSAMPLEVALUE  "; break;
	        case SMAXSAMPLEVALUE           : sz = "SMAXSAMPLEVALUE  "; break;
	        case JPEGPROC                  : sz = "JPEGPROC         "; break;
	        case JPEGIFOFFSET              : sz = "JPEGIFOFFSET     "; break;
	        case JPEGIFBYTECOUNT           : sz = "JPEGIFBYTECOUNT  "; break;
	        case JPEGRESTARTINTERVAL       : sz = "JPEGRESTARTINTERVAL "; break;
	        case JPEGLOSSLESSPREDICTORS    : sz = "JPEGLOSSLESSPREDICTORS "; break;
	        case JPEGPOINTTRANSFORM        : sz = "JPEGPOINTTRANSFORM "; break;   
	        case JPEGQTABLES               : sz = "JPEGQTABLES      "; break;
	        case JPEGDCTABLES              : sz = "JPEGDCTABLES     "; break;
	        case JPEGACTABLES              : sz = "JPEGACTABLES     "; break;
	        case YCBCRCOEFFICIENTS         : sz = "YCBCRCOEFFICIENTS "; break;       
	        case YCBCRSUBSAMPLING          : sz = "YCBCRSUBSAMPLING "; break;
	        case YCBCRPOSITIONING          : sz = "YCBCRPOSITIONING "; break;
	        case REFERENCEBLACKWHITE       : sz = "REFERENCEBLACKWHITE "; break;    
	        case REFPTS               : sz = "REFPTS      		"; break; 
	        case REGIONTACKPOINT      : sz = "REGIONTACKPOINT   "; break; 
	        case REGIONWARPCORNERS    : sz = "REGIONWARPCORNERS "; break; 
	        case REGIONAFFINE         : sz = "REGIONAFFINE      "; break; 
	        case MATTEING             : sz = "MATTEING      	"; break; 
	        case DATATYPE             : sz = "DATATYPE      	"; break; 
	        case IMAGEDEPTH           : sz = "IMAGEDEPTH      	"; break; 
	        case TILEDEPTH            : sz = "TILEDEPTH      	"; break; 
	        case PIXAR_IMAGEFULLWIDTH : sz = "PIXAR_IMAGEFULLWIDTH "; break; 
	        case PIXAR_IMAGEFULLLENGTH: sz = "PIXAR_IMAGEFULLLENGTH "; break; 
	        case WRITERSERIALNUMBER   : sz = "WRITERSERIALNUMBER "; break; 
	        case COPYRIGHT            : sz = "COPYRIGHT      	"; break; 
	        case IT8SITE              : sz = "IT8SITE      		"; break; 
	        case IT8COLORSEQUENCE     : sz = "IT8COLORSEQUENCE  "; break; 
	        case IT8HEADER            : sz = "IT8HEADER      	"; break; 
	        case IT8RASTERPADDING     : sz = "IT8RASTERPADDING  "; break; 
	        case IT8BITSPERRUNLENGTH  : sz = "IT8BITSPERRUNLENGTH "; break; 
	        case IT8BITSPEREXTENDEDRUNLENGTH: sz = "IT8BITSPEREXTENDEDRUNLENGTH "; break; 
	        case IT8COLORTABLE        : sz = "IT8COLORTABLE     "; break; 
	        case IT8IMAGECOLORINDICATOR: sz = "IT8IMAGECOLORINDICATOR "; break; 
	        case IT8BKGCOLORINDICATOR : sz = "IT8BKGCOLORINDICATOR "; break; 
	        case IT8IMAGECOLORVALUE   : sz = "IT8IMAGECOLORVALUE "; break; 
	        case IT8BKGCOLORVALUE     : sz = "IT8BKGCOLORVALUE  "; break; 
	        case IT8PIXELINTENSITYRANGE: sz = "IT8PIXELINTENSITYRANGE "; break; 
	        case IT8TRANSPARENCYINDICATOR: sz = "IT8TRANSPARENCYINDICATOR "; break; 
	        case IT8COLORCHARACTERIZATION: sz = "IT8COLORCHARACTERIZATION "; break; 
	        case FRAMECOUNT           : sz = "FRAMECOUNT      	"; break; 
	        case ICCPROFILE           : sz = "ICCPROFILE      	"; break; 
	        case JBIGOPTIONS          : sz = "JBIGOPTIONS      	"; break; 
	        case FAXRECVPARAMS        : sz = "FAXRECVPARAMS     "; break; 
	        case FAXSUBADDRESS        : sz = "FAXSUBADDRESS     "; break; 
	        case FAXRECVTIME          : sz = "FAXRECVTIME      	"; break; 
	        case DCSHUESHIFTVALUES    : sz = "DCSHUESHIFTVALUES "; break; 

	        case UNISYS_ISIS_IFD: sz = "UNISYS_ISIS_IFD"; break;
	        case UNISYS_SIDE: sz = "UNISYS_SIDE"; break; 
	        case UNISYS_IXPS_IFD: sz = "UNISYS_IXPS_IFD"; break;
	        case WEIRD: sz = "BANCTEC_IFD"; break; 
			
			default : 
				sz="Unknown Tag #" + id + " "; 
				break; 
        }                                                                  
		return sz;		
	}
	}
}