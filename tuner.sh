init 4
sleep 3
sed -i '/^config\.Nims\./d' /etc/enigma2/settings
cat << 'EOF' >> /etc/enigma2/settings
config.Nims.0.configMode=advanced
config.Nims.0.advanced.sat.3300.lnb=2
config.Nims.0.advanced.sat.19.lnb=6
config.Nims.0.advanced.sat.30.lnb=6
config.Nims.0.advanced.sat.90.lnb=8
config.Nims.0.advanced.sat.100.lnb=8
config.Nims.0.advanced.sat.130.lnb=1
config.Nims.0.advanced.sat.160.lnb=7
config.Nims.0.advanced.sat.192.lnb=5
config.Nims.0.advanced.sat.260.lnb=3
config.Nims.0.advanced.lnb.2.diseqcMode=1_1
config.Nims.0.advanced.lnb.2.commandOrder=cut
config.Nims.0.advanced.lnb.2.uncommittedDiseqcCommand=2
config.Nims.0.advanced.lnb.6.diseqcMode=1_1
config.Nims.0.advanced.lnb.6.commandOrder=cut
config.Nims.0.advanced.lnb.6.uncommittedDiseqcCommand=6
config.Nims.0.advanced.lnb.8.diseqcMode=1_1
config.Nims.0.advanced.lnb.8.commandOrder=cut
config.Nims.0.advanced.lnb.8.uncommittedDiseqcCommand=8
config.Nims.0.advanced.lnb.1.diseqcMode=1_1
config.Nims.0.advanced.lnb.1.commandOrder=cut
config.Nims.0.advanced.lnb.1.uncommittedDiseqcCommand=1
config.Nims.0.advanced.lnb.7.diseqcMode=1_1
config.Nims.0.advanced.lnb.7.commandOrder=cut
config.Nims.0.advanced.lnb.7.uncommittedDiseqcCommand=7
config.Nims.0.advanced.lnb.5.diseqcMode=1_1
config.Nims.0.advanced.lnb.5.commandOrder=cut
config.Nims.0.advanced.lnb.5.uncommittedDiseqcCommand=5
config.Nims.0.advanced.lnb.3.diseqcMode=1_1
config.Nims.0.advanced.lnb.3.commandOrder=cut
config.Nims.0.advanced.lnb.3.uncommittedDiseqcCommand=3
config.Nims.0.advanced.sats=3300
config.Nims.0.hdsAlesDeOm=true
EOF
init 3
