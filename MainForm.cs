using System;
using System.Drawing;
using System.Windows.Forms;
using HHMS_Application.Forms;

namespace HHMS_Application
{
    public partial class MainForm : Form
    {
        public MainForm()
        {
            InitializeComponent();
        }

        private void InitializeComponent()
        {
            this.Text = "HHMS Application - Trung Tâm Ngoại Ngữ 68";
            this.Size = new Size(1000, 700);
            this.StartPosition = FormStartPosition.CenterScreen;
            this.WindowState = FormWindowState.Normal;

            // Create main panel
            Panel mainPanel = new Panel
            {
                Dock = DockStyle.Fill,
                BackColor = Color.FromArgb(240, 242, 245),
                Padding = new Padding(20)
            };

            // Create title label
            Label titleLabel = new Label
            {
                Text = "HHMS - Hệ thống Quản lý Trung Tâm Ngoại Ngữ 68",
                Font = new Font("Inter", 18, FontStyle.Bold),
                ForeColor = Color.FromArgb(45, 55, 72),
                AutoSize = false,
                Size = new Size(mainPanel.Width - 40, 50),
                TextAlign = ContentAlignment.MiddleCenter,
                Location = new Point(20, 20)
            };

            // Create description label
            Label descLabel = new Label
            {
                Text = "Chọn chức năng bạn muốn sử dụng:",
                Font = new Font("Inter", 12, FontStyle.Regular),
                ForeColor = Color.FromArgb(74, 85, 104),
                AutoSize = false,
                Size = new Size(mainPanel.Width - 40, 30),
                TextAlign = ContentAlignment.MiddleLeft,
                Location = new Point(20, 80)
            };

            // Create buttons panel with flow layout
            FlowLayoutPanel buttonsPanel = new FlowLayoutPanel
            {
                Location = new Point(20, 120),
                Size = new Size(mainPanel.Width - 40, mainPanel.Height - 160),
                FlowDirection = FlowDirection.LeftToRight,
                WrapContents = true,
                AutoScroll = true,
                Padding = new Padding(10)
            };

            // Define buttons with their corresponding forms
            var buttons = new[]
            {
                new { Text = "Đăng nhập", FormType = typeof(LoginForm), Color = Color.FromArgb(59, 130, 246) },
                new { Text = "Bảng điều khiển", FormType = typeof(DashBoardForm), Color = Color.FromArgb(16, 185, 129) },
                new { Text = "Quản lý Tài khoản", FormType = typeof(AccountandAccessManagementForm), Color = Color.FromArgb(139, 92, 246) },
                new { Text = "Quản lý Chi nhánh", FormType = typeof(BranchManagementForm), Color = Color.FromArgb(236, 72, 153) },
                new { Text = "Đổi mật khẩu", FormType = typeof(ChangePassWordForm), Color = Color.FromArgb(245, 158, 11) },
                new { Text = "Mô tả Lớp học", FormType = typeof(ClassDescriptionForm), Color = Color.FromArgb(34, 197, 94) },
                new { Text = "Danh sách Lớp", FormType = typeof(ClassListForm), Color = Color.FromArgb(168, 85, 247) },
                new { Text = "Quản lý Phòng ban", FormType = typeof(DepartmentManagementForm), Color = Color.FromArgb(239, 68, 68) },
                new { Text = "Danh sách Tài liệu", FormType = typeof(DocumentListForm), Color = Color.FromArgb(14, 165, 233) },
                new { Text = "Chỉnh sửa Lương", FormType = typeof(EditSalaryTableForm), Color = Color.FromArgb(168, 162, 158) },
                new { Text = "Tài chính", FormType = typeof(FinancialDashBoardForm), Color = Color.FromArgb(5, 150, 105) },
                new { Text = "Chấm công", FormType = typeof(KeepingtimeForm), Color = Color.FromArgb(217, 119, 6) },
                new { Text = "Nhật ký", FormType = typeof(LogForm), Color = Color.FromArgb(107, 114, 128) },
                new { Text = "Chuyên ngành", FormType = typeof(MajorListForm), Color = Color.FromArgb(192, 38, 211) },
                new { Text = "Tạo Báo cáo", FormType = typeof(ReportCreateForm), Color = Color.FromArgb(220, 38, 127) },
                new { Text = "Tạo Yêu cầu", FormType = typeof(RequestCreateForm), Color = Color.FromArgb(2, 132, 199) },
                new { Text = "Tóm tắt Yêu cầu", FormType = typeof(RequestSummaryForm), Color = Color.FromArgb(7, 89, 133) },
                new { Text = "Mô tả Lương", FormType = typeof(SalaryDescriptionForm), Color = Color.FromArgb(101, 163, 13) },
                new { Text = "Nhân viên", FormType = typeof(StaffListForm), Color = Color.FromArgb(194, 65, 12) },
                new { Text = "Học sinh", FormType = typeof(StudentListForm), Color = Color.FromArgb(147, 51, 234) },
                new { Text = "TCode v3", FormType = typeof(TCodeDefinitionVersion3Form), Color = Color.FromArgb(79, 70, 229) },
                new { Text = "Ca học GV", FormType = typeof(TeacherEditShiftLearnForm), Color = Color.FromArgb(190, 24, 93) },
                new { Text = "Tusision", FormType = typeof(TusisionForm), Color = Color.FromArgb(15, 118, 110) }
            };

            // Create buttons
            foreach (var buttonInfo in buttons)
            {
                Button btn = new Button
                {
                    Text = buttonInfo.Text,
                    Size = new Size(180, 60),
                    Font = new Font("Inter", 10, FontStyle.Medium),
                    BackColor = buttonInfo.Color,
                    ForeColor = Color.White,
                    FlatStyle = FlatStyle.Flat,
                    Margin = new Padding(5),
                    Cursor = Cursors.Hand,
                    Tag = buttonInfo.FormType
                };

                btn.FlatAppearance.BorderSize = 0;
                btn.FlatAppearance.MouseOverBackColor = ControlPaint.Light(buttonInfo.Color, 0.1f);
                btn.FlatAppearance.MouseDownBackColor = ControlPaint.Dark(buttonInfo.Color, 0.1f);

                btn.Click += (sender, e) =>
                {
                    try
                    {
                        var formType = (Type)((Button)sender).Tag;
                        Form form = (Form)Activator.CreateInstance(formType);
                        form.Show();
                    }
                    catch (Exception ex)
                    {
                        MessageBox.Show($"Lỗi khi mở form: {ex.Message}", "Lỗi", 
                                       MessageBoxButtons.OK, MessageBoxIcon.Error);
                    }
                };

                buttonsPanel.Controls.Add(btn);
            }

            // Add controls to main panel
            mainPanel.Controls.Add(titleLabel);
            mainPanel.Controls.Add(descLabel);
            mainPanel.Controls.Add(buttonsPanel);

            // Add main panel to form
            this.Controls.Add(mainPanel);

            // Handle form resize
            this.Resize += (sender, e) =>
            {
                titleLabel.Size = new Size(mainPanel.Width - 40, 50);
                descLabel.Size = new Size(mainPanel.Width - 40, 30);
                buttonsPanel.Size = new Size(mainPanel.Width - 40, mainPanel.Height - 160);
            };
        }
    }
}