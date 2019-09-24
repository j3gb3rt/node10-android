FROM node:10-buster-slim

ENV SDK="sdk-tools-linux-4333796.zip"
ENV PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/share/android-sdk-linux/tools:/usr/share/android-sdk-linux/tools/bin:/usr/share/android-sdk-linux/platform-tools"

RUN mkdir /usr/share/man/man1 \
 && apt-get update && apt-get -y -f upgrade \
 && apt-get install -y default-jdk lib32stdc++6 lib32z1 unzip

RUN echo "mkdir /usr/share/android-sdk-linux" \
    && mkdir /usr/share/android-sdk-linux \
    && echo "cd /usr/share/android-sdk-linux" \
    && cd /usr/share/android-sdk-linux \
    && echo "wget \"https://dl.google.com/android/repository/$SDK\"" \
    && wget "https://dl.google.com/android/repository/$SDK" \
    && echo 'unzip "$SDK" && rm "$SDK"' \
    && unzip "$SDK" && rm "$SDK" \
    && echo "dkmanager --list" \
    && sdkmanager --list \
    && echo 'sdkmanager "platform-tools" "platforms;android-28" "build-tools;28.0.3" "docs" "tools"' \
    && echo 'y' | sdkmanager "platform-tools" "platforms;android-28" "build-tools;28.0.3" "docs" "tools"
    #    echo y | android update sdk -u -a -t 1,3,4,26,27

VOLUME /workspace
WORKDIR /workspace

ENTRYPOINT ["/bin/bash"]
