FROM node:10-stretch-slim

ENV SDK="sdk-tools-linux-4333796.zip"
ENV PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/share/android-sdk-linux/tools:/usr/share/android-sdk-linux/tools/bin:/usr/share/android-sdk-linux/platform-tools"

RUN mkdir /usr/share/man/man1 \
 && apt-get update && apt-get -y -f upgrade \
 && apt-get install -y openjdk-8-jdk lib32stdc++6 lib32z1 unzip

RUN npm install -g cordova

# Setup android sdk
RUN echo "mkdir /usr/share/android-sdk-linux" \
    && mkdir /usr/share/android-sdk-linux \
    && echo "cd /usr/share/android-sdk-linux" \
    && cd /usr/share/android-sdk-linux \
    && echo "wget \"https://dl.google.com/android/repository/$SDK\"" \
    && wget "https://dl.google.com/android/repository/$SDK" \
    && echo 'unzip "$SDK" && rm "$SDK"' \
    && unzip "$SDK" && rm "$SDK" \
    && echo "sdkmanager --list" \
    && sdkmanager --list \
    && echo 'sdkmanager "platform-tools" "platforms;android-28" "build-tools;28.0.3" "docs" "tools"' \
    && echo 'y' | sdkmanager "platform-tools" "platforms;android-28" "build-tools;28.0.3" "docs" "tools"

# Setup gradle
ENV GRADLE_HOME /opt/gradle

ENV GRADLE_VERSION 5.6.2

ARG GRADLE_DOWNLOAD_SHA256=32fce6628848f799b0ad3205ae8db67d0d828c10ffe62b748a7c0d9f4a5d9ee0

RUN set -o errexit -o nounset \
    && echo "Downloading Gradle" \
    && wget --no-verbose --output-document=gradle.zip "https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip" \
    \
    && echo "Checking download hash" \
    && echo "${GRADLE_DOWNLOAD_SHA256} *gradle.zip" | sha256sum --check - \
    \
    && echo "Installing Gradle" \
    && unzip gradle.zip \
    && rm gradle.zip \
    && mv "gradle-${GRADLE_VERSION}" "${GRADLE_HOME}/" \
    && ln --symbolic "${GRADLE_HOME}/bin/gradle" /usr/bin/gradle \
    \
    && echo "Testing Gradle installation" \
    && gradle --version

VOLUME /workspace
WORKDIR /workspace
