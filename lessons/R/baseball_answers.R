bat<-read.table("/Users/eric/Google Drive/CSUMB/ENVS550/lectures/DataTypes_Cleaning/batting_players08.txt",header=T, sep="\t",stringsAsFactors=F)

#Challenge 1
table(bat$bats,bat$throws,bat$lgID)

#Challenge 2
BRTL<-bat[which(bat$bats=="R" & bat$throws=="L" & bat$lgID=="NL"),c("nameFirst","nameLast","RBI")]

#Challenge 3
BRTL[order(BRTL[,3],decreasing=T),]

