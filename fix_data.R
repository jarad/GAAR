library(chron)

fix_data = function(d) 
{
  d = na.omit(d)

  Start     = times(paste(d$Start_Hr, d$Start_Min, d$Start_Sec, sep=":"))
  Kayak_End = times(paste(d$Kayak_Hr, d$Kayak_Min, d$Kayak_Sec, sep=":"))
  Bike_End  = times(paste(d$Bike_Hr,  d$Bike_Min,  d$Bike_Sec,  sep=":"))
  End       = times(paste(d$Run_Hr,   d$Run_Min,   d$Run_Sec,   sep=":"))

  d$Kayak = as.character(Kayak_End - Start)
  d$Bike  = as.character(Bike_End  - Kayak_End)
  d$Run   = as.character(End       - Bike_End)
  d$Total = as.character(End       - Start)

  return(d[,c("Bib","Bib2","Name","Cat1","Cat2","Cat3","Kayak","Bike","Run","Total")])
}

