;+
; NAME:
;      READ_EXT_DATA
;
; PURPOSE:
;      READ the data for an extinction curve.
;
; CATEGORY:
;      Extinction Curves.
;
; CALLING SEQUENCE:
;      READ_EXT_DATA,data_file,ext_data
;
; INPUTS:
;      data_file : name of data file
;
; KEYWORD PARAMETERS:
;
; OUTPUTS:
;      ext_data : extinction data structure
;
; RESTRICTIONS:
;      This program written for research use.  No warrenties are
;      given.  Use at your own risk.
;
; PROCEDURE:
;
; EXAMPLE:
;
; MODIFICATION HISTORY:
;     Written by  : Karl D. Gordon (2 Jan 2006)
;      6 Oct 2008 : Added reading of FM90 parameters (KDG)
;-
pro read_ext_data,data_file,ext_data,fm90_param=fm90_param

; check we got at least 2 parameters
if (N_params() LT 2) then begin
    print, 'Syntax - read_ext_data, data_file, ext_data'
    return
endif

; read in the primary header for basic information
fits_read,data_file,dummy,header,/header_only,/pdu

; detemine type of extiction curve
exttype = strtrim(fxpar(header,'EXTTYPE'),2)

; get the filenames that went into making the extinction curve
red_file = fxpar(header,'R_FILE')
comp_file = fxpar(header,'C_FILE')

; what spectroscopic extinction curves exist
;iue_exists = fxpar(header,'IUEDATA')
;fuse_exists = fxpar(header,'FUSEDATA')
;irs_exists = fxpar(header,'IRSDATA')

; get basic data
av = fxpar(header,'AV')
av_unc = fxpar(header,'AV_UNC')
av_unc_d = fxpar(header,'AV_UNC_D')
rv = fxpar(header,'RV')
rv_unc = fxpar(header,'RV_UNC')
rv_unc_d = fxpar(header,'RV_UNC_D')
ebv = fxpar(header,'EBV')
ebv_unc = fxpar(header,'EBV_UNC')
ebv_unc_d = fxpar(header,'EBV_UNC_')

; get the FM data (if it exists)
fm_tmp = fxpar(header,'FMC2',count=fm_exists)
if (fm_exists) then begin
    C = fltarr(4)
    C_unc = C
    C_unc_ran = C
    C_unc_sys = C
    C_unc_comp = C
    bump = fltarr(2)
    bump_unc = bump
    bump_unc_sys = bump
    bump_unc_ran = bump
    bump_unc_comp = bump
    
    for i = 0,3 do begin
        C[i] = fxpar(header,'FMC' + strtrim(string(i+1),2))
        C_unc[i] = fxpar(header,'FMC' + strtrim(string(i+1),2) + 'U')
        C_unc_sys[i] = fxpar(header,'FMC' + strtrim(string(i+1),2) + 'U_S')
        C_unc_ran[i] = fxpar(header,'FMC' + strtrim(string(i+1),2) + 'U_R')
        C_unc_comp[i] = fxpar(header,'FMC' + strtrim(string(i+1),2) + 'U_D')
    endfor

    bump[0] = fxpar(header,'FMx0')
    bump_unc[0] = fxpar(header,'FMx0U')
    bump_unc_sys[0] = fxpar(header,'FMx0U_S')
    bump_unc_ran[0] = fxpar(header,'FMx0U_R')
    bump_unc_comp[0] = fxpar(header,'FMx0U_D')

    bump[1] = fxpar(header,'FMgam')
    bump_unc[1] = fxpar(header,'FMgamU')
    bump_unc_sys[1] = fxpar(header,'FMgamU_S')
    bump_unc_ran[1] = fxpar(header,'FMgamU_R')
    bump_unc_comp[1] = fxpar(header,'FMgamU_D')

    fm90_param = {C : C, $
                  C_unc_comp : C_unc_comp, $
                  C_unc_sys : C_unc_sys, $
                  C_unc_ran : C_unc_ran, $
                  C_unc : C_unc, $
                  bump : bump, $
                  bump_unc_comp : bump_unc_comp, $
                  bump_unc_sys : bump_unc_sys, $
                  bump_unc_ran : bump_unc_ran, $
                  bump_unc : bump_unc}
    
endif

; get number of extensions
fits_open,data_file,fcb
n_extend = fcb.nextend
fits_close,fcb

; defaults
iue_exists = 0
iue_ext = 0
fuse_exists = 0
fuse_ext = 0
nir_exists = 0
nir_ext = 0
irs_exists = 0
irs_ext = 0

; get spectroscopic extinction data
for i = 1,n_extend do begin
    ext = mrdfits(data_file,i,header,/silent)
    extname = strtrim(fxpar(header,'EXTNAME'),2)
    case 1 of
        strcmp(extname,'BANDEXT') : band_ext = ext
        strcmp(extname,'IUEEXT') : begin
            iue_ext = ext
            iue_exists = 1
        end
        strcmp(extname,'FUSEEXT') : begin
            fuse_ext = ext
            fuse_exists = 1
        end
        strcmp(extname,'IRSEXT') : begin
            irs_ext = ext
            irs_exists = 1
        end
        strcmp(extname,'NIREXT') : begin
            nir_ext = ext
            nir_exists = 1
        end
        else : begin
            print,'***Extension not recognized in ' + data_file
            print,'extname = ' + extname
            stop
        end
    endcase
endfor

; create extinction structure
ext_data = {red_file : red_file, $
            comp_file : comp_file, $
            ext_type : exttype, $
            av : av, $
            av_unc : av_unc, $
            av_unc_comp : av_unc_d, $
            ebv : ebv, $
            ebv_unc : ebv_unc, $
            ebv_unc_comp : ebv_unc_d, $
            rv : rv, $
            rv_unc : rv_unc, $
            rv_unc_comp : rv_unc_d, $
            band_ext : band_ext, $
            iue_exists : iue_exists, $
            iue_ext : iue_ext, $
            fuse_exists : fuse_exists, $
            fuse_ext : fuse_ext, $
            nir_exists : nir_exists, $
            nir_ext : nir_ext, $
            irs_exists : irs_exists, $
            irs_ext : irs_ext $
            }

end
