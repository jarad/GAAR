library(chron)

get_times = function(d) 
{
  Start     = times(paste(d$Start_Hr, d$Start_Min, d$Start_Sec, sep=":"))
  Kayak_End = times(paste(d$Kayak_Hr, d$Kayak_Min, d$Kayak_Sec, sep=":"))
  Bike_End  = times(paste(d$Bike_Hr,  d$Bike_Min,  d$Bike_Sec,  sep=":"))
  End       = times(paste(d$Run_Hr,   d$Run_Min,   d$Run_Sec,   sep=":"))

  d$Kayak = as.character(Kayak_End - Start)
  d$Bike  = as.character(Bike_End  - Kayak_End)
  d$Run   = as.character(End       - Bike_End)
  d$Total = as.character(End       - Start)

  d$Start_Hr <- d$Start_Min <- d$Start_Sec <- NULL
  d$Kayak_Hr <- d$Kayak_Min <- d$Kayak_Sec <- NULL
  d$Bike_Hr <- d$Bike_Min <- d$Bike_Sec <- NULL
  d$Run_Hr <- d$Run_Min <- d$Run_Sec <- NULL

  return(d)
}