# Jenkins'in JDK 21 ile çalışan temel imajını kullanıyoruz
FROM jenkins/jenkins:jdk21

# Root yetkileriyle çalışıyoruz
USER root

# Chrome ve bağımlılıklarının yüklenmesi
RUN apt-get update && apt-get install -y \
    wget \
    gnupg2 \
    curl \
    unzip \
    firefox-esr \
    libnss3 \
    libx11-xcb1 \
    libxcb1 \
    libxcomposite1 \
    libxrandr2 \
    libxi6 \
    libxcursor1 \
    libxdamage1 \
    libxtst6 \
    libpango1.0-0 \
    && wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list \
    && apt-get update \
    && apt-get install -y google-chrome-stable

# ChromeDriver'ı yükle
RUN CHROME_DRIVER_VERSION=$(curl -sS chromedriver.storage.googleapis.com/LATEST_RELEASE) \
    && wget -N https://chromedriver.storage.googleapis.com/${CHROME_DRIVER_VERSION}/chromedriver_linux64.zip \
    && unzip chromedriver_linux64.zip -d /usr/local/bin/ \
    && rm chromedriver_linux64.zip \
    && chmod +x /usr/local/bin/chromedriver

# Jenkins'in kullanıcısına geri dönüyoruz
USER jenkins