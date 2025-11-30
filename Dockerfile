# 1. 베이스 이미지: Node.js 18 버전 (가벼운 슬림 버전)
FROM node:18-slim

# 2. 필수 패키지 설치 (Chromium 브라우저 + 한글 폰트 + 시스템 라이브러리)
# 오라클 ARM 서버에서도 작동하도록 chromium을 직접 설치합니다.
RUN apt-get update && apt-get install -y \
    chromium \
    fonts-nanum \
    fonts-ipafont-gothic \
    fonts-freefont-ttf \
    --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

# 3. 작업 디렉토리 설정
WORKDIR /usr/src/app

# 4. 의존성 파일 복사 및 설치
COPY package*.json ./

# puppeteer-core가 설치된 크롬을 찾지 못해 다운로드하려 할 때 에러를 방지합니다.
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium

RUN npm install

# 5. 소스 코드 복사
COPY . .

# 6. 포트 노출 (사용 중인 포트가 다르면 수정 필요, 보통 3000이나 8080)
EXPOSE 3000

# 7. 서버 실행
CMD ["node", "server.js"]