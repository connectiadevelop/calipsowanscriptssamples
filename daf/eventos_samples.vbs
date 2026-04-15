'Ejemplo de evento 2 de DAF para alterar propiedades de las columnas del daf.
sub daf_onbeforeexecute2( dafprops )

  dim propitem
  
  '**** Parametros
  f.storeparams "afecha",campo("daf_afecha")
  f.storeparams "descaj",campo("daf_descaj")
  f.storeparams "hascaj",campo("daf_hascaj")
  f.storeparams "cotizacion",campo("daf_cotizacion")
  f.storeparams "saldoini",campo("daf_saldoini")
  f.storeparams "esquema",campo("daf_esquema")
  
  '**** Condiciones de campos visibles ****
  for each propitem in dafprops
  select case propitem("id")
  case "EXP3" : propitem("visible")=campo("cotizacion")="B" and campo("saldoini")="S"
  case "EXP4" : propitem("visible")=campo("cotizacion")="B"
  case "EXP5" : propitem("visible")=campo("cotizacion")="B"
  case "EXP6" : propitem("visible")=campo("cotizacion")="B"
  case "EXP7" : propitem("visible")=campo("cotizacion")="T" and campo("saldoini")="S"
  case "EXP8" : propitem("visible")=campo( "cotizacion")="T"
  case "EXP9" : propitem("visible")=campo("cotizacion")="T"
  case "EXP10" : propitem("visible")=campo("cotizacion")="T"
  case "EXP11" : propitem("visible")=campo("cotizacion")="T"
  end select
  next

end sub


Ejemplo de evento "pre-vista"

sub daf_onbeforeview( v )

f.cartel v.sql

v.columnas.removeid "c15"
v.addconstante "(select .... from......)", "c15"

dim cuentasexcluidas
cuentasexcluidas="'01.','011','013','023','025','03.','041','087','31.'"
'**** vista de reporte
v.reset
'*** tablas
v.addtabla "Qcajamovcotiza","Cajamov"
v.addtabla "qcajas","qcajas"
v.addjoin "qcajas","ljoin","cajamov.cuenta","qcajas.cuenta"
v.addtabla "Monedas","Monedas"
'v.addjoin "Monedas","ljoin","cajamov.monedaid","monedas.codigo"
v.addjoin "Monedas","ljoin","isnull(cajamov.monedaid,'PES')","monedas.codigo"
v.addtabla "cajatipo","ct"
v.addjoin "ct","ljoin","cajamov.tipo","ct.tipo"
'*** columnas OBLIGATORIAS
v.addconstante v.char("1"),"id"
v.addconstante v.char("1"),"c_agrupadic"
'*** columnas de reporte
v.addconstante "'Caja: '+cajamov.cuenta+'  '+qcajas.nombre","c1"
v.addgrupo "'Caja: '+cajamov.cuenta+'  '+qcajas.nombre"
v.addconstante "ct.nombre","c2"
v.addconstante f.vFunc("Sum", f.vfunc("decode", f.vfunc( "sign", f.vFunc( "datediff",  db.valorfecha( campo("afecha")),"cajamov.fecha")), -1, f.vfunc("-", "cajamov.impentra", "cajamov.impsale"),0) ),"c3"
v.addconstante v.func("isnull",f.vFunc("Sum", f.vfunc("decode", f.vfunc( "sign", f.vFunc( "datediff",  db.valorfecha( campo("afecha")),"cajamov.fecha")), -1,0,"impentra" ) ),"0"),"c4"
v.addconstante v.func("isnull",f.vFunc("Sum", f.vfunc("decode", f.vfunc( "sign", f.vFunc( "datediff",  db.valorfecha( campo("afecha")),"cajamov.fecha")), -1,0,"impsale" ) ),"0"),"c5"
v.addconstante v.func("isnull","sum(  impentra-impsale)","0"),"c6"
v.addconstante f.vFunc("Sum", f.vfunc("decode", f.vfunc( "sign", f.vFunc( "datediff",  db.valorfecha( campo("afecha")),"cajamov.fecha")), -1, f.vfunc( "/", f.vfunc( "-", "cajamov.impentra", "cajamov.impsale"), "cajamov.cotizacion"),0 )),"c7"
v.addconstante v.func("isnull",f.vFunc("Sum", f.vfunc("decode", f.vfunc( "sign", f.vFunc( "datediff",  db.valorfecha( campo("afecha")),"cajamov.fecha")), -1, 0,  f.vfunc( "/", "cajamov.impentra", "cajamov.cotizacion") )),"0"),"c8"
v.addconstante v.func("isnull",f.vFunc("Sum", f.vfunc("decode", f.vfunc( "sign", f.vFunc( "datediff",  db.valorfecha( campo("afecha")),"cajamov.fecha")), -1,0, f.vfunc( "/", "cajamov.impsale", "cajamov.cotizacion") )),"0"),"c9"
v.addconstante v.func("isnull","sum( ( cajamov.impentra - cajamov.impsale )/cajamov.cotizacion  )","0"),"c10"
v.addconstante "monedas.nombre","c11"
v.addgrupo "ct.nombre"
v.addgrupo "monedas.nombre"
v.addhaving "isnull(sum( cajamov.impentra-cajamov.impsale),0) >= 0.01 OR isnull(sum( cajamov.impentra-cajamov.impsale),0) <= (-0.01)"
'**** condición de repote aplicado a vista ****
v.addcondicion "cajamov.fecha <= "+db.valorfecha(campo("afecha"))+"and cajamov.cuenta NOT IN("& cuentasexcluidas &") and cajamov.cuenta between '"+campo("descaj")+"' AND '"+campo("hascaj")+"' and cajamov.caja='S' and (cajamov.impentra<>0 or cajamov.impsale<>0) and cajamov.dbschemaid = '"+campo("esquema")+"'"

if f.userid="NMAINA" THEN F.CARTEL DAFVIEW.SQL END IF

end sub
