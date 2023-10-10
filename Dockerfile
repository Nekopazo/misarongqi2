FROM nginx:latest
EXPOSE 80
WORKDIR /app
USER root

COPY nginx.conf /etc/nginx/nginx.conf
COPY config.json ./
COPY entrypoint.sh ./

RUN apt-get update && apt-get install -y wget unzip iproute2 systemctl && \
    wget -O temp.zip https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip && \
    unzip temp.zip xray && \
    rm -f temp.zip && \
    chmod -v 755 xray entrypoint.sh

# 下载并安装 frpc
RUN wget https://github.com/fatedier/frp/releases/download/v0.51.3/frp_0.51.3_linux_amd64.zip && \
    tar -xzvf frp_0.51.3_linux_amd64.tar.gz && \
    mv frp_0.51.3_linux_amd64/frpc /usr/local/bin/ && \
    rm -rf frp_0.51.3_linux_amd64.tar.gz frp_0.51.3_linux_amd64

# 创建配置文件，你需要将 frpc 配置文件拷贝到容器内
COPY frpc.ini /etc/frpc.ini

# 定义 frpc 启动命令
CMD ["/usr/local/bin/frpc", "-c", "/etc/frpc.ini"]

ENTRYPOINT [ "./entrypoint.sh" ]
