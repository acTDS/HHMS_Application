// API Configuration
const API_CONFIG = {
    BASE_URL: 'http://localhost:5000/api', // Development API URL
    TIMEOUT: 10000 // 10 seconds timeout
};

// API Helper Functions
class ApiClient {
    constructor(baseUrl = API_CONFIG.BASE_URL) {
        this.baseUrl = baseUrl;
    }

    async request(endpoint, options = {}) {
        const url = `${this.baseUrl}${endpoint}`;
        const defaultOptions = {
            headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json'
            },
            timeout: API_CONFIG.TIMEOUT
        };

        const config = { ...defaultOptions, ...options };

        try {
            const response = await fetch(url, config);
            
            if (!response.ok) {
                throw new Error(`HTTP ${response.status}: ${response.statusText}`);
            }

            const data = await response.json();
            return { success: true, data };
        } catch (error) {
            console.error(`API Request failed for ${endpoint}:`, error);
            return { success: false, error: error.message };
        }
    }

    // Dashboard API methods
    async getDashboardMetrics() {
        return this.request('/dashboard/metrics');
    }

    async getDashboardSummary() {
        return this.request('/dashboard/summary');
    }

    async getDailyActivities() {
        return this.request('/dashboard/activities');
    }

    async getUpcomingClasses() {
        return this.request('/dashboard/upcoming-classes');
    }

    async getPendingRequests() {
        return this.request('/dashboard/pending-requests');
    }

    // Staff API methods
    async getStaff(params = {}) {
        const queryString = new URLSearchParams(params).toString();
        return this.request(`/staff${queryString ? '?' + queryString : ''}`);
    }

    async getStaffById(id) {
        return this.request(`/staff/${id}`);
    }

    async createStaff(staffData) {
        return this.request('/staff', {
            method: 'POST',
            body: JSON.stringify(staffData)
        });
    }

    async updateStaff(id, staffData) {
        return this.request(`/staff/${id}`, {
            method: 'PUT',
            body: JSON.stringify(staffData)
        });
    }

    async deleteStaff(id) {
        return this.request(`/staff/${id}`, {
            method: 'DELETE'
        });
    }

    // TCode API methods
    async getTCodes(userRole = 'default') {
        return this.request(`/tcode?userRole=${userRole}`);
    }

    async validateTCode(tcode, userRole = 'default') {
        return this.request('/tcode/validate', {
            method: 'POST',
            body: JSON.stringify({ TCode: tcode, UserRole: userRole })
        });
    }

    // User API methods
    async getUserInfo(userId = null) {
        return this.request(`/user/info${userId ? '?userId=' + userId : ''}`);
    }

    async login(username, password) {
        return this.request('/user/login', {
            method: 'POST',
            body: JSON.stringify({ Username: username, Password: password })
        });
    }

    async logout() {
        return this.request('/user/logout', {
            method: 'POST'
        });
    }

    async changePassword(currentPassword, newPassword, confirmPassword) {
        return this.request('/user/change-password', {
            method: 'POST',
            body: JSON.stringify({
                CurrentPassword: currentPassword,
                NewPassword: newPassword,
                ConfirmPassword: confirmPassword
            })
        });
    }
}

// Initialize API client
const apiClient = new ApiClient();

// Mock data fallbacks (used when API is not available)
const MOCK_DATA = {
    metrics: [
        { title: "Tổng số nhân viên", value: "42", change: "+3%", icon: "fas fa-users", category: "HR" },
        { title: "Chi nhánh hoạt động", value: "3", change: "0%", icon: "fas fa-building", category: "General" },
        { title: "Phòng ban", value: "5", change: "+1%", icon: "fas fa-sitemap", category: "General" }
    ],
    activities: [
        { icon: "👤", details: "Nhân viên mới được thêm vào hệ thống", time: "10:30" },
        { icon: "📊", details: "Báo cáo tháng đã được tạo", time: "09:15" },
        { icon: "🔧", details: "Cập nhật cấu hình hệ thống", time: "08:45" }
    ],
    classes: [
        { title: "Huấn luyện nhân viên mới", instructor: "GV. Nguyễn Văn A", schedule: "Thứ 2, 9:00 - 11:00", students: "12 nhân viên" },
        { title: "Khóa đào tạo Excel nâng cao", instructor: "GV. Trần Thị B", schedule: "Thứ 4, 14:00 - 16:00", students: "8 nhân viên" }
    ],
    requests: [
        { details: "Yêu cầu thay đổi lịch làm việc", time: "Hôm nay, 11:20" },
        { details: "Đơn xin nghỉ phép", time: "Hôm nay, 10:15" },
        { details: "Yêu cầu cập nhật thông tin cá nhân", time: "Hôm qua, 16:30" }
    ],
    tcodes: [
        { tcode: "T001", description: "Dashboard - Trang tổng quan", requiredRole: ["admin", "manager", "hr", "default"], iconClass: "fas fa-tachometer-alt" },
        { tcode: "T002", description: "Quản lý nhân viên", requiredRole: ["admin", "hr"], iconClass: "fas fa-users" },
        { tcode: "T003", description: "Quản lý học viên", requiredRole: ["admin", "teacher"], iconClass: "fas fa-user-graduate" },
        { tcode: "T004", description: "Quản lý lớp học", requiredRole: ["admin", "teacher"], iconClass: "fas fa-chalkboard-teacher" },
        { tcode: "T005", description: "Quản lý tài chính", requiredRole: ["admin"], iconClass: "fas fa-chart-line" },
        { tcode: "T006", description: "Quản lý tài liệu", requiredRole: ["admin", "teacher"], iconClass: "fas fa-folder" },
        { tcode: "T007", description: "Báo cáo thống kê", requiredRole: ["admin", "manager"], iconClass: "fas fa-chart-bar" },
        { tcode: "T008", description: "Quản lý tài khoản", requiredRole: ["admin"], iconClass: "fas fa-user-cog" }
    ],
    user: {
        name: "Administrator",
        title: "Quản trị viên hệ thống",
        role: "admin",
        email: "admin@nn68.edu.vn",
        department: "Công nghệ thông tin",
        branch: "Chi nhánh chính"
    }
};

// Utility functions
function showMessage(message, type = 'info') {
    console.log(`[${type.toUpperCase()}] ${message}`);
    // You can integrate this with your existing showCustomMessageBox function
    if (typeof showCustomMessageBox === 'function') {
        showCustomMessageBox(message);
    }
}

function formatCurrency(amount) {
    return new Intl.NumberFormat('vi-VN', {
        style: 'currency',
        currency: 'VND'
    }).format(amount);
}

function formatDate(date) {
    return new Intl.DateTimeFormat('vi-VN', {
        year: 'numeric',
        month: 'long',
        day: 'numeric'
    }).format(new Date(date));
}

// Export for use in HTML files
if (typeof window !== 'undefined') {
    window.apiClient = apiClient;
    window.MOCK_DATA = MOCK_DATA;
    window.showMessage = showMessage;
    window.formatCurrency = formatCurrency;
    window.formatDate = formatDate;
}