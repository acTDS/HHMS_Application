using System;
using System.Drawing;
using System.Linq;
using System.Threading.Tasks;
using System.Windows.Forms;
using HHMS_Application.Services;
using HHMS_Application.Models;

namespace HHMS_Application
{
    public class MainForm : BaseAPIForm
    {
        private readonly DashboardService _dashboardService;
        private readonly RequestService _requestService;

        // Dashboard panels
        private Panel metricsPanel;
        private Panel chartPanel;
        private Panel recentActivityPanel;
        private Panel quickActionsPanel;

        // Metric cards
        private Panel totalStudentsCard;
        private Panel totalStaffCard;
        private Panel pendingRequestsCard;
        private Panel approvedRequestsCard;

        // Quick action buttons
        private Button btnManageStudents;
        private Button btnManageStaff;
        private Button btnViewRequests;
        private Button btnManageAccounts;

        // Data grid for recent activities
        private DataGridView dgvRecentRequests;

        public MainForm() : base("HHMS Dashboard - Trung Tâm Ngoại Ngữ 68")
        {
            _dashboardService = new DashboardService();
            _requestService = new RequestService();
            
            this.Size = new Size(1400, 900);
            this.WindowState = FormWindowState.Maximized;
            this.StartPosition = FormStartPosition.CenterScreen;
        }

        protected override void InitializeFormControls()
        {
            CreateDashboardLayout();
            CreateMetricCards();
            CreateQuickActions();
            CreateRecentActivitiesGrid();
        }

        private void CreateDashboardLayout()
        {
            // Create main layout
            var topPanel = new Panel
            {
                Dock = DockStyle.Top,
                Height = 180,
                Padding = new Padding(10)
            };

            var bottomPanel = new Panel
            {
                Dock = DockStyle.Fill,
                Padding = new Padding(10)
            };

            // Metrics panel (top)
            metricsPanel = new Panel
            {
                Dock = DockStyle.Fill,
                BackColor = Color.Transparent
            };

            topPanel.Controls.Add(metricsPanel);

            // Create splitter for bottom section
            var splitter = new SplitContainer
            {
                Dock = DockStyle.Fill,
                SplitterDistance = 300,
                FixedPanel = FixedPanel.Panel1
            };

            // Quick actions panel (left)
            quickActionsPanel = new Panel
            {
                Dock = DockStyle.Fill,
                BackColor = Color.White,
                Padding = new Padding(10)
            };

            // Recent activity panel (right)
            recentActivityPanel = new Panel
            {
                Dock = DockStyle.Fill,
                BackColor = Color.White,
                Padding = new Padding(10)
            };

            splitter.Panel1.Controls.Add(quickActionsPanel);
            splitter.Panel2.Controls.Add(recentActivityPanel);
            bottomPanel.Controls.Add(splitter);

            mainPanel.Controls.Add(bottomPanel);
            mainPanel.Controls.Add(topPanel);
        }

        private void CreateMetricCards()
        {
            // Create 4 metric cards in a horizontal layout
            var cardWidth = (metricsPanel.Width - 50) / 4;
            var cardHeight = 140;
            var spacing = 10;

            // Total Students Card
            totalStudentsCard = CreateMetricCard("Tổng Học Viên", "0", "fas fa-user-graduate", Color.FromArgb(52, 144, 220));
            totalStudentsCard.Location = new Point(spacing, 20);
            totalStudentsCard.Size = new Size(cardWidth, cardHeight);

            // Total Staff Card
            totalStaffCard = CreateMetricCard("Tổng Nhân Viên", "0", "fas fa-users", Color.FromArgb(40, 167, 69));
            totalStaffCard.Location = new Point(cardWidth + spacing * 2, 20);
            totalStaffCard.Size = new Size(cardWidth, cardHeight);

            // Pending Requests Card
            pendingRequestsCard = CreateMetricCard("Yêu Cầu Chờ Duyệt", "0", "fas fa-clock", Color.FromArgb(255, 193, 7));
            pendingRequestsCard.Location = new Point((cardWidth + spacing) * 2 + spacing, 20);
            pendingRequestsCard.Size = new Size(cardWidth, cardHeight);

            // Approved Requests Card
            approvedRequestsCard = CreateMetricCard("Đã Phê Duyệt", "0", "fas fa-check-circle", Color.FromArgb(40, 167, 69));
            approvedRequestsCard.Location = new Point((cardWidth + spacing) * 3 + spacing, 20);
            approvedRequestsCard.Size = new Size(cardWidth, cardHeight);

            metricsPanel.Controls.AddRange(new Control[] {
                totalStudentsCard, totalStaffCard, pendingRequestsCard, approvedRequestsCard
            });
        }

        private Panel CreateMetricCard(string title, string value, string iconClass, Color color)
        {
            var card = new Panel
            {
                BackColor = Color.White,
                BorderStyle = BorderStyle.FixedSingle
            };

            var titleLabel = new Label
            {
                Text = title,
                Font = new Font("Segoe UI", 10, FontStyle.Bold),
                ForeColor = Color.FromArgb(108, 117, 125),
                Location = new Point(15, 15),
                AutoSize = true
            };

            var valueLabel = new Label
            {
                Text = value,
                Font = new Font("Segoe UI", 24, FontStyle.Bold),
                ForeColor = color,
                Location = new Point(15, 40),
                AutoSize = true,
                Name = "valueLabel" // For easy access when updating
            };

            var iconLabel = new Label
            {
                Text = "📊", // Using emoji as placeholder for icon
                Font = new Font("Segoe UI", 20),
                ForeColor = color,
                Location = new Point(card.Width - 50, 15),
                AutoSize = true
            };

            card.Controls.AddRange(new Control[] { titleLabel, valueLabel, iconLabel });
            return card;
        }

        private void CreateQuickActions()
        {
            var groupBox = CreateGroupBox("Thao Tác Nhanh");
            groupBox.Dock = DockStyle.Fill;

            btnManageStudents = CreateButton("Quản Lý Học Viên", Color.FromArgb(0, 123, 255), Color.White, 250, 40);
            btnManageStudents.Location = new Point(20, 40);
            btnManageStudents.Click += (s, e) => OpenStudentManagement();

            btnManageStaff = CreateButton("Quản Lý Nhân Viên", Color.FromArgb(40, 167, 69), Color.White, 250, 40);
            btnManageStaff.Location = new Point(20, 90);
            btnManageStaff.Click += (s, e) => OpenStaffManagement();

            btnViewRequests = CreateButton("Xem Yêu Cầu", Color.FromArgb(255, 193, 7), Color.Black, 250, 40);
            btnViewRequests.Location = new Point(20, 140);
            btnViewRequests.Click += (s, e) => OpenRequestSummary();

            btnManageAccounts = CreateButton("Quản Lý Tài Khoản", Color.FromArgb(108, 117, 125), Color.White, 250, 40);
            btnManageAccounts.Location = new Point(20, 190);
            btnManageAccounts.Click += (s, e) => OpenAccountManagement();

            groupBox.Controls.AddRange(new Control[] {
                btnManageStudents, btnManageStaff, btnViewRequests, btnManageAccounts
            });

            quickActionsPanel.Controls.Add(groupBox);
        }

        private void CreateRecentActivitiesGrid()
        {
            var groupBox = CreateGroupBox("Yêu Cầu Gần Đây");
            groupBox.Dock = DockStyle.Fill;

            dgvRecentRequests = CreateDataGridView();
            dgvRecentRequests.Dock = DockStyle.Fill;

            // Add columns
            dgvRecentRequests.Columns.Add("RequestCode", "Mã YC");
            dgvRecentRequests.Columns.Add("Title", "Tiêu Đề");
            dgvRecentRequests.Columns.Add("Requester", "Người Yêu Cầu");
            dgvRecentRequests.Columns.Add("Status", "Trạng Thái");
            dgvRecentRequests.Columns.Add("SubmissionDate", "Ngày Gửi");

            // Set column widths
            dgvRecentRequests.Columns["RequestCode"].Width = 100;
            dgvRecentRequests.Columns["Title"].Width = 200;
            dgvRecentRequests.Columns["Requester"].Width = 150;
            dgvRecentRequests.Columns["Status"].Width = 120;
            dgvRecentRequests.Columns["SubmissionDate"].Width = 100;

            dgvRecentRequests.CellDoubleClick += (s, e) => {
                if (e.RowIndex >= 0)
                {
                    // Open request details
                    OpenRequestSummary();
                }
            };

            groupBox.Controls.Add(dgvRecentRequests);
            recentActivityPanel.Controls.Add(groupBox);
        }

        protected override async Task LoadDataAsync()
        {
            await ExecuteWithLoadingAsync(async () =>
            {
                // Load dashboard summary
                var summaryResponse = await _dashboardService.GetDashboardSummaryAsync();
                if (summaryResponse.Success)
                {
                    var summary = summaryResponse.Data;
                    UpdateMetricCards(summary);
                }

                // Load recent requests
                var requestsResponse = await _requestService.GetRequestSummaryAsync(1, pageSize: 10);
                if (requestsResponse.Success)
                {
                    UpdateRecentRequests(requestsResponse.Data);
                }
            }, "Đang tải dữ liệu dashboard...");
        }

        private void UpdateMetricCards(dynamic summary)
        {
            // Update total students
            if (totalStudentsCard.Controls["valueLabel"] is Label studentsLabel)
                studentsLabel.Text = summary.TotalStudents.ToString();

            // Update total staff
            if (totalStaffCard.Controls["valueLabel"] is Label staffLabel)
                staffLabel.Text = summary.TotalStaff.ToString();

            // Update pending requests
            if (pendingRequestsCard.Controls["valueLabel"] is Label pendingLabel)
                pendingLabel.Text = (summary.PendingAppraisal + summary.PendingApproval).ToString();

            // Update approved requests
            if (approvedRequestsCard.Controls["valueLabel"] is Label approvedLabel)
                approvedLabel.Text = summary.Approved.ToString();
        }

        private void UpdateRecentRequests(System.Collections.Generic.List<RequestSummary> requests)
        {
            dgvRecentRequests.Rows.Clear();
            
            foreach (var request in requests.Take(10))
            {
                dgvRecentRequests.Rows.Add(
                    request.RequestCode,
                    request.Title,
                    request.RequesterName,
                    request.StatusDisplayName,
                    request.SubmissionDate.ToString("dd/MM/yyyy")
                );
            }
        }

        private void OpenStudentManagement()
        {
            var studentForm = new Forms.StudentListForm();
            studentForm.Show();
        }

        private void OpenStaffManagement()
        {
            var staffForm = new Forms.StaffListForm();
            staffForm.Show();
        }

        private void OpenRequestSummary()
        {
            var requestForm = new Forms.RequestSummaryForm();
            requestForm.Show();
        }

        private void OpenAccountManagement()
        {
            var accountForm = new Forms.AccountandAccessManagementForm();
            accountForm.Show();
        }

        protected override void OnResize(EventArgs e)
        {
            base.OnResize(e);
            
            // Recalculate metric card sizes and positions when form is resized
            if (metricsPanel?.Controls.Count > 0)
            {
                var cardWidth = Math.Max(200, (metricsPanel.Width - 50) / 4);
                var spacing = 10;
                var cards = new[] { totalStudentsCard, totalStaffCard, pendingRequestsCard, approvedRequestsCard };

                for (int i = 0; i < cards.Length; i++)
                {
                    if (cards[i] != null)
                    {
                        cards[i].Size = new Size(cardWidth, 140);
                        cards[i].Location = new Point((cardWidth + spacing) * i + spacing, 20);
                    }
                }
            }
        }
    }
}