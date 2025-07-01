pipeline {
    // Gunakan 'agent any' karena Jenkins kini dijalankan dari image kustom
    // yang sudah memiliki Docker terinstal. Ini lebih sederhana dan efisien.
    agent any

    stages {
        // Tahap 'Clone' tidak diperlukan lagi.
        // Jenkins secara otomatis melakukan 'checkout' kode dari SCM
        // sebelum menjalankan pipeline ini.

        stage('1. Install Dependencies') {
            steps {
                echo 'Menginstall dependensi via Composer di dalam container...'
                // Menggunakan ${WORKSPACE} adalah cara Jenkins yang paling andal
                // untuk merujuk ke direktori kerja saat ini.
                sh 'docker run --rm -v "${WORKSPACE}":/app -w /app composer/composer install'
            }
        }

        stage('2. Run Unit Tests') {
            steps {
                echo 'Menjalankan unit tests...'
                sh 'docker run --rm -v "${WORKSPACE}":/app -w /app php:8.0-cli ./vendor/bin/phpunit tests/SimpleTest.php'
            }
        }

        stage('3. Build Docker Image') {
            steps {
                echo 'Membangun Docker image aplikasi...'
                sh 'docker build -t php-app:latest .'
            }
        }

        stage('4. Deploy Application') {
            steps {
                echo 'Mendeploy aplikasi...'
                sh 'docker stop php-app-container || true'
                sh 'docker rm php-app-container || true'
                // Port diubah ke 8083 sesuai permintaan.
                sh 'docker run -d --name php-app-container -p 8083:80 php-app:latest'
                echo "Aplikasi berhasil di-deploy dan berjalan di port 8083."
            }
        }
    }
    post {
        success {
            echo 'PIPELINE BERHASIL! Selamat!'
        }
        failure {
            echo 'Pipeline gagal!'
        }
    }
}