# Инфраструктурная платформа для приложений <br> на базе managed Kubernetes Yandex Cloud

Инфраструктура платформы включает:
- Мониторинг кластера и приложения с алертами и дашбордами с использованием kube prometheus stack (Prometheus, Grafana, Alert manager и т.д.)
- Централизованное логирование для кластера и приложений с использовнием Loki и Promtail
- CI/CD пайплайн для приложений с использованием gitops инструмента Argo CD

CI/CD данного репозитория позволяет развернуть платформу со всеми компонентами, а также демонстрационное приложение - [Online Boutique by Google](https://github.com/GoogleCloudPlatform/microservices-demo).
Для развертывания платформы используются утилиты Terraform и CLI Yandex Cloud.