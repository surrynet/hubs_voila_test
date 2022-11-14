# Voila repo2docker Application
* Dockerfile을 환경에 맞게 수정한다.
* jupyterlab에서 이미지를 본인의 ID로 빌드한다.
```
sudo repo2docker --user-id $UID --user-name admin --image-name hubs_voila_test --no-run https://github.com/surrynet/hubs_voila_test.git 
```
## docker compose 환경에서 테스트
* proxy의 CONFIGPROXY_AUTH_TOKEN 환경변수가 있어야 한다.
```
docker run -ti --rm --env CONFIGPROXY_AUTH_TOKEN=ConfigProxy --network pioneer --name voila hubs_voila_test hubs_voila create -s moon -p 8866 /index.ipynb
```
* browser
  * http://localhost:8000/voila/moon/
## docker swarm 환경에서 테스트
```
docker stack deploy -c voila.yaml pioneer
```
* browser - proxy URL or traefik URL
  * http[s]://localhost:8000/voila/moon/
  * http[s]://{DOMAIN}/voila/moon/
