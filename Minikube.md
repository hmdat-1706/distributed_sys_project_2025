Minikube:

-------

1\. Lý thuyết cơ sở Minikube:

\- Khái niệm Containerization (Docker).

\- Giới thiệu Kubernetes: Mục đích, lợi ích, và các vấn đề K8s giải quyết.

\- Các thành phần cốt lõi của K8s (Master Node, Worker Node, Kube-apiserver, etcd, Kubelet, Kube-proxy).

Cho P3

* \- Deployment: Khái niệm, vai trò, và cách quản lý trạng thái mong muốn của Pods.
* \- Pod: Đơn vị triển khai nhỏ nhất.
* \- Service: Khái niệm, vai trò, và các loại Service phổ biến (ClusterIP, NodePort, LoadBalancer). 

Cho P4

* \- Sự cần thiết của việc tách cấu hình khỏi code (12-Factor App).
* \- ConfigMap: Dùng để lưu trữ dữ liệu cấu hình không nhạy cảm.
* \- Secret: Dùng để lưu trữ dữ liệu nhạy cảm (mật khẩu, khóa API).
* \- Các phương pháp chèn ConfigMap/Secret vào Pod (Environment Variables, Files).

Cho P5

\- Phân biệt Pods (stateless) và Yêu cầu dữ liệu bền vững (stateful).

\- PersistentVolume (PV): Tài nguyên lưu trữ vật lý/mạng của cluster.

\- PersistentVolumeClaim (PVC): Yêu cầu của Pod đối với tài nguyên lưu trữ.

Cho P6.

\- Scaling ngang (Horizontal Scaling): Thêm Pods.

\- Resource Requests \& Limits: Thiết lập tài nguyên cho Pods (CPU, Memory).

\- Horizontal Pod Autoscaler (HPA): Khái niệm và cách tự động điều chỉnh số lượng Pods dựa trên tải (CPU/Memory).

Cho P7.

\- Giới hạn của Service NodePort/LoadBalancer.

\- Ingress: Khái niệm, vai trò như một bộ định tuyến Layer 7 (HTTP/HTTPS) cho cluster.

\- Ingress Controller: Vai trò của Nginx/Traefik trong K8s.

\- Phân biệt giữa Ingress và Service.





Tổng kết: Minikube: Vai trò, và giới hạn so với K8s đầy đủ. (học cô Dung rồi đừng đưa ra lợi ích giùm con)

2\. Install Minikube, chạy một cluster basic (Cài đặt, Khởi động và Quản lý Cluster cơ bản).

**\*\* Thống nhất là mình chạy Minikube trên Ubuntu (nên từ 22.04 trở lên, t chạy 24.04), hoặc environment Ubuntu WSL2**

**\*\* Tạo .sh demo going thầy luôn**

* Install Minikube
* Start a basic Cluster, verify status that this Cluster is working!
* Stop a Cluster (Minikube Stop, 
* Delete a Cluster Minikube Delete)
* Dashboard (Minikube Dashboard) tracking Cluster 

-- Ref: https://www.facebook.com/share/v/17UoNcPK1G/

-- Minh Dat: CN (23h59: 7/12)

---------



3\. Running một Web app trên Minikube

\*\* Có thể sử dung cái web nginx làm LAB3 để Deploy, hoặc tạo cái nào tuỳ thích 

\- Tạo Docker Image cho một ứng dụng web đơn giản (ví dụ: Node.js/Python).

\- Viết manifest YAML cho Deployment và Service (NodePort).

\- Triển khai và truy cập ứng dụng thông qua minikube service \[service-name].

-- Ref: https://www.facebook.com/share/v/1GkBgfXXNR/



4\. Cấu hình ConfigMaps and Secrets ()

\- Tạo ConfigMap chứa URL database hoặc port.

\- Tạo Secret chứa mật khẩu database.

\- Điều chỉnh manifest Deployment để inject ConfigMap và Secret vào Pod, sau đó kiểm tra ứng dụng.

-- Ref: https://www.youtube.com/watch?v=FAnQTgr04mU

5\. 

\- Viết manifest cho PVC.

\- Triển khai một ứng dụng cần lưu trữ (ví dụ: một database đơn giản như SQLite) sử dụng PVC.

\- Chứng minh tính bền vững: Xóa Pod và kiểm tra xem dữ liệu có còn nguyên vẹn khi Pod mới được tạo lại không.

-- Ref: https://www.youtube.com/watch?v=0swOh5C3OVM\&t=458s

-- NhatDang: T7 (23h59: 6/12)

-------

6\. Scaling một Web app trên Minikube

\- Scaling thủ công: Sử dụng kubectl scale --replicas=X để tăng/giảm số lượng Pods.

\- Triển khai HPA: Sử dụng manifest để cấu hình HPA dựa trên mức sử dụng CPU (ví dụ: duy trì 50% CPU).

\- Kiểm tra HPA: Tạo tải giả (load test) lên ứng dụng và quan sát HPA tự động tăng số lượng Pods.

-- Ref: https://www.facebook.com/share/v/1BSK2MvtGu/



7.(Công bố và Định tuyến nâng cao (Ingress Controller)) (bao gồm Deploy một FastAPI app trên Minisub)

\- Bật addon Ingress trong Minikube (minikube addons enable ingress).

\- Triển khai hai ứng dụng web riêng biệt (ví dụ: app-frontend và app-api).

\- Viết manifest Ingress để định tuyến giao thông: Ví dụ: myapp.local/ đến frontend, myapp.local/api đến backend.

-- Ref: https://www.facebook.com/share/v/15psJyngbK/

-- Ref: https://www.youtube.com/watch?v=80Ew\_fsV4rM

-- HaiDang: T7 (23h59: 6/12)

