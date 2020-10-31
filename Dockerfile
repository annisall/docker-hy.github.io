FROM jekyll/jekyll:3.8.3 as build-stage

ARG PORT

WORKDIR /tmp

COPY Gemfile* ./

RUN bundle install

RUN echo $PORT

WORKDIR /usr/src/app

COPY . .

RUN chown -R jekyll .

RUN jekyll build

FROM nginx:alpine

COPY --from=build-stage /usr/src/app/_site/ /usr/share/nginx/html

COPY nginx.conf /etc/nginx/nginx.conf

CMD sed -i -e 's/$PORT/'"$PORT"'/g' /etc/nginx/nginx.conf && cat /etc/nginx/nginx.conf && nginx -g 'daemon off;'