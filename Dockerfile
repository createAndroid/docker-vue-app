# as --> 여기 FROM 부터 다음 FROM 전까지는 builder stage라는 것을 명시
FROM node:alpine as builder

WORKDIR /usr/src/app

LABEL email="ghrp8277@naver.com"

LABEL name="lee"

LABEL version="1.0"

LABEL description="TEST 입니다."

COPY package.json .

RUN npm install

COPY ./ ./

RUN npm run build

FROM nginx
# --from -> 다른 stage에 있는 파일을 복사할때 다른 stage 이름을 명시
# builder stage에서 생성된 파일들은 /usr/src/app/build에 들어가게 되며 그곳에 저장된 파일들을 /var/www/html로 복사를 시켜줘서
# nginx가 웹 브라우저의 http 요청이 올때 마다 알맞은 파일을 전해 줄 수 있게 만듭니다.

# /var/www/html 장소로 build 파일들을 복사 시켜주는 이유는 이 장소로 파일을 넣어 두면 nginx가 알아서 client에서 요청이 들어올때 알맞은 정적 파일들을
# 제공해줌. 이장소는 설정을 통해서 바꿀수 있음
COPY --from=builder /usr/src/app /usr/share/nginx

COPY ./nginx/default.conf /etc/nginx/conf.d
# docker builder .
# docker run -p 8080:80

# 컨테이너 전체 삭제
# $ docker rm $(docker ps -a -q)
# 이미지 전체 삭제
# $ docker rmi $(docker images -q)