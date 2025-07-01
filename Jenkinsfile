pipeline {
    // Jalankan seluruh pipeline di dalam sebuah container Docker
    // yang sudah memiliki Docker client terinstal.
    agent {
        docker {
            image 'docker:20.10.17' // Menggunakan image Docker resmi yang berisi CLI
            args '-v /var/run/docker.sock:/var/run/docker.sock' // Memberi akses ke Docker socket host
        }
    }

    stages {
        stage('1. Clone Repository') {
            steps {
                echo 'Mulai proses clone...'
                // Jenkins otomatis melakukan clone saat menggunakan 'Pipeline script from SCM'
                // Langkah git di sini bersifat eksplisit untuk kejelasan alur.
                git branch: 'main', url: 'https://github.com/muhananaufal/php-jenkins-docker.git'
                echo 'Clone repository berhasil.'
            }
        }

        stage('2. Install Dependencies') {
            steps {
                echo 'Menginstall dependensi via Composer...'
                // Menggunakan sh untuk menjalankan perintah di shell agent Jenkins
                sh 'docker run --rm -v "$(pwd)":/app -w /app composer/composer install'
                echo 'Dependensi berhasil diinstall.'
            }
        }

        stage('3. Run Unit Tests') {
            steps {
                echo 'Menjalankan unit tests...'
                // Menjalankan PHPUnit dari folder vendor
                sh 'docker run --rm -v "$(pwd)":/app -w /app php:8.0-cli ./vendor/bin/phpunit tests/SimpleTest.php'
                echo 'Unit tests selesai.'
            }
        }

        stage('4. Build Docker Image') {
            steps {
                echo 'Membangun Docker image...'
                // Memberi nama dan tag pada image
                sh 'docker build -t php-app:latest .'
                echo 'Docker image berhasil dibangun.'
            }
        }

        stage('5. Deploy Application') {
            steps {
                echo 'Mendeploy aplikasi...'
                // Hentikan dan hapus container lama jika ada untuk menghindari konflik port
                sh 'docker stop php-app-container || true'
                sh 'docker rm php-app-container || true'

                // Jalankan container baru dari image yang telah di-build
                // Memetakan port 8083 di host ke port 80 di container
                sh 'docker run -d --name php-app-container -p 8083:80 php-app:latest'
                echo 'Aplikasi berhasil di-deploy dan berjalan di port 8083.'
            }
        }
    }
    post {
        success {
            echo 'Pipeline berhasil dijalankan!'
        }
        failure {
            echo 'Pipeline gagal!'
        }
    }
}
