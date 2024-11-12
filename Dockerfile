# 베이스 이미지로 Node.js 사용
FROM node:16 AS build

# 작업 디렉토리 설정
WORKDIR /app

# 필요한 파일을 복사하고 의존성 설치
COPY package.json package-lock.json ./
RUN npm install

# 애플리케이션 빌드
COPY . .
RUN npm run build

# 경량 Nginx 서버로 이동하여 정적 파일 서빙
FROM nginx:stable-alpine
COPY --from=build /app/build /usr/share/nginx/html

# Cloud Run에서 포트 설정
EXPOSE 8080
CMD ["nginx", "-g", "daemon off;"]
