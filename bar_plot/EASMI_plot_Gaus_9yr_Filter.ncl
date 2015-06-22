;
;===================================================

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
;==================================================
begin

;	indir = "../indices_data/"
	
;====load index data ==============================
	ncol = 9
	data	   = readAsciiTable("EAMI1948-present.ascii",ncol,"float",(/3,0/))

;	printVarSummary(easm_hadslp2)
;	print(easm_hadslp2(:,0))
;	print(easm_sw(:,0))
;	print(easm_ncep(:,0))
	year = data(:,0)
	easm = data(:,1:8)


;==== run 9 year Gaussian-type filted data ============
	opt = 0
	runy = 9
	yr = 4 ; (runy-1)/2
	wgt_f9   = filwgts_normal (runy, 0.5, 0)
;	print(wgt_f7)
;easm_s
	dim = dimsizes(easm)
	tmp_nam = new((/dim(0)+(runy-1),dim(1)/),float)

	do it=0,yr-1
		tmp_nam(it,:) = easm(0,:)
	end do 
	tmp_nam(yr:dim(0) + yr-1,:) = easm 
	do it = dim(0) + yr, dim(0) + runy-2
		tmp_nam(it,:) = easm(dim(0)-1,:)	
	end do
	tmp_f9_nam 	= wgt_runave_n(tmp_nam , wgt_f9, opt, 0)
	f9_easm = tmp_f9_nam(yr:dim(0) + yr-1,:)
	delete(tmp_nam)
	delete(tmp_f9_nam)
;=====plot index=======================================
	easm_ind = 7	; the column index of NAM index represent : DJF , JJA and ANN
	;print(easm_ind)
    
    color = (/"white","black","blue","red","yellow"/)
	res   = True
	res@gsnDraw  = False
	res@gsnFrame = False
 	res@gsnScale = True

	res@tmBorderThicknessF = 1.0
	res@tmXBLabelFontThicknessF = 0.1
	res@tmXMajorGridThicknessF = 0.1
	res@tmXMinorGridThicknessF = 0.01
	res@tmYMajorGridThicknessF = 0.1
	res@tmYMinorGridThicknessF = 0.01
	res@tmYLMinorOn 	= True
	res@tmYLMinorLengthF = 0.004
	res@tmYLMajorLengthF = 0.008
	res@tmXBMajorLengthF = 0.008
	res@tmXBMinorOn      = False
	res@tmXTMinorOn      = False	
	res@tmXBLabelFontHeightF	= 0.015
	res@tmYLLabelFontHeightF	= 0.015
	
	res@gsnXYBarChartBarWidth  = 0.4
	
	res@tmXBMode = "Manual"
	res@tmXBTickStartF = 1950
	res@tmXBTickEndF = 2010	
	res@tmXBTickSpacingF = 5
	
;	res@vpXF      = 0.10        ; In page coordinates, where to start
; 	res@vpYF      = 0.75        ; the plot
 	res@vpHeightF = 0.25        ; Changes the aspect ratio
 	res@vpWidthF  = 0.9

 	res@gsnYRefLine           = 0.              ; reference line   
 	res@gsnXYBarChart         = True            ; create bar chart 
    res@xyLineColors = (/"red","blue"/)         ; colors for the above/blow
    res@xyLineThicknessF = 0.01
 	res@gsnXYBarChartOutlineThicknessF = 0.0
 	res@gsnXYBarChartFillLineThicknessF = 0.0
 	res@gsnAboveYRefLineColor = "red"           ; above ref line fill red
 	res@gsnBelowYRefLineColor = "blue"          ; below ref line fill blue

	polyres                  = True
    polyres@gsLineThicknessF = 4.0
    polyres@gsLineColor		 = "black"
; 	res@tiYAxisString = "Anomalies" ; y-axis label      
 	res@tiMainString  = "East Asia Summer Monsoon Index" ; title

;************
    wks   = gsn_open_wks ("eps", "EASMI" )
    gsn_define_colormap(wks,color)
 	res@trYMinF   = -2.5        ; min value on y-axis
 	res@trYMaxF   =  3.        ; max value on y-axis
    plot0 = gsn_csm_xy (wks,year,easm(:,easm_ind),res)	
    dum0 = gsn_add_polyline(wks,plot0,year,f9_easm(:,easm_ind),polyres) ; add polyline

    resP = True
	resP@gsnMaximize    = True                ; maximize plots
;	resP@gsnAttachBorderOn	= True
;	resP@gsnPanelCenter		= False
	resP@gsnPaperOrientation = "portrait"
;  	resP@gsnPanelBottom      = 0.05                ; extra space at bottom
 	resP@gsnPanelYWhiteSpacePercent = 5         ; 1.0 is the default
  	gsn_panel(wks,(/plot0/),(/1,1/),resP)          ; now draw as one plot

end
