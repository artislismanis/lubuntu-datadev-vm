#!/bin/bash -e

echo "==> Installing RStudio..."
rm -rf /opt/rstudio
curl -sO https://download1.rstudio.org/desktop/bionic/amd64/rstudio-1.3.959-amd64-relwithdebinfo-debian.tar.gz
mkdir -p /opt/rstudio
tar xfz rstudio-1.3.959-amd64-relwithdebinfo-debian.tar.gz --directory /opt/rstudio
cd /opt/rstudio/
ln -sfn /opt/rstudio/rstudio-1.3.959 latest

cat << 'EOF' > /etc/profile.d/rstudio.sh
#!/bin/bash
export PATH=/opt/rstudio/latest/bin:${PATH}
export LD_LIBRARY_PATH=/opt/rstudio/latest/lib:${LD_LIBRARY_PATH}
EOF

chmod +x /etc/profile.d/rstudio.sh

cat << 'EOF' > rstudio.desktop
[Desktop Entry]
Name=RStudio
Type=Application
Exec=/opt/rstudio/latest/bin/rstudio
Terminal=false
Icon=/opt/rstudio/latest/rstudio.png
Comment=Integrated Development Environment
NoDisplay=false
Categories=Development;IDE;
EOF

desktop-file-install rstudio.desktop

rm -f rstudio-1.3.959-amd64-relwithdebinfo-debian.tar.gz
rm -f rstudio.desktop