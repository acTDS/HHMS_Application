using System;
using System.Drawing;
using System.Linq;
using System.Threading.Tasks;
using System.Windows.Forms;
using HHMS_Application.Services;
using HHMS_Application.Models;

namespace HHMS_Application.Forms
{
    public class AccountandAccessManagementForm : BaseAPIForm
    {
        private readonly AccountService _accountService;

        // Controls
        private Panel searchPanel;
        private TextBox txtSearch;
        private ComboBox cbRole;
        private ComboBox cbStatus;
        private Button btnSearch;
        private Button btnRefresh;

        private DataGridView dgvAccounts;
        private Panel buttonPanel;
        private Button btnAdd;
        private Button btnEdit;
        private Button btnResetPassword;
        private Button btnLockUnlock;
        private Button btnPermissions;

        public AccountandAccessManagementForm() : base("Quản Lý Tài Khoản & Truy Cập")
        {
            _accountService = new AccountService();
        }

        protected override void InitializeFormControls()
        {
            CreateSearchPanel();
            CreateDataGrid();
            CreateButtonPanel();
            SetupEventHandlers();
        }

        private void CreateSearchPanel()
        {
            searchPanel = new Panel
            {
                Dock = DockStyle.Top,
                Height = 80,
                BackColor = Color.FromArgb(248, 249, 250),
                Padding = new Padding(20, 15, 20, 15)
            };

            var searchLabel = new Label
            {
                Text = "Tìm kiếm:",
                Font = new Font("Segoe UI", 10, FontStyle.Bold),
                Location = new Point(0, 8),
                AutoSize = true
            };

            txtSearch = CreateTextBox("Nhập tên, email hoặc mã nhân viên...");
            txtSearch.Location = new Point(80, 5);
            txtSearch.Width = 250;

            var roleLabel = new Label
            {
                Text = "Vai trò:",
                Font = new Font("Segoe UI", 10, FontStyle.Bold),
                Location = new Point(350, 8),
                AutoSize = true
            };

            cbRole = CreateComboBox();
            cbRole.Location = new Point(410, 5);
            cbRole.Width = 150;

            var statusLabel = new Label
            {
                Text = "Trạng thái:",
                Font = new Font("Segoe UI", 10, FontStyle.Bold),
                Location = new Point(580, 8),
                AutoSize = true
            };

            cbStatus = CreateComboBox();
            cbStatus.Location = new Point(660, 5);
            cbStatus.Width = 150;

            btnSearch = CreateButton("Tìm Kiếm", Color.FromArgb(0, 123, 255), Color.White, 100, 30);
            btnSearch.Location = new Point(830, 5);

            btnRefresh = CreateButton("Làm Mới", Color.FromArgb(108, 117, 125), Color.White, 100, 30);
            btnRefresh.Location = new Point(940, 5);

            searchPanel.Controls.AddRange(new Control[] {
                searchLabel, txtSearch, roleLabel, cbRole, statusLabel, cbStatus, btnSearch, btnRefresh
            });

            mainPanel.Controls.Add(searchPanel);
        }

        private void CreateDataGrid()
        {
            dgvAccounts = CreateDataGridView();
            dgvAccounts.Dock = DockStyle.Fill;

            // Add columns
            dgvAccounts.Columns.Add("AccountID", "ID");
            dgvAccounts.Columns.Add("StaffCode", "Mã NV");
            dgvAccounts.Columns.Add("FullName", "Họ Tên");
            dgvAccounts.Columns.Add("Username", "Tên Đăng Nhập");
            dgvAccounts.Columns.Add("Email", "Email");
            dgvAccounts.Columns.Add("RoleName", "Vai Trò");
            dgvAccounts.Columns.Add("AccountStatus", "Trạng Thái TK");
            dgvAccounts.Columns.Add("LastLogin", "Đăng Nhập Cuối");
            dgvAccounts.Columns.Add("IsLocked", "Khóa");
            dgvAccounts.Columns.Add("LoginAttempts", "Lần Thử");
            dgvAccounts.Columns.Add("EffectivePermissionCount", "Số Quyền");
            dgvAccounts.Columns.Add("CreatedDate", "Ngày Tạo");

            // Hide ID column
            dgvAccounts.Columns["AccountID"].Visible = false;

            // Set column widths
            dgvAccounts.Columns["StaffCode"].Width = 100;
            dgvAccounts.Columns["FullName"].Width = 180;
            dgvAccounts.Columns["Username"].Width = 130;
            dgvAccounts.Columns["Email"].Width = 200;
            dgvAccounts.Columns["RoleName"].Width = 120;
            dgvAccounts.Columns["AccountStatus"].Width = 100;
            dgvAccounts.Columns["LastLogin"].Width = 130;
            dgvAccounts.Columns["IsLocked"].Width = 60;
            dgvAccounts.Columns["LoginAttempts"].Width = 80;
            dgvAccounts.Columns["EffectivePermissionCount"].Width = 80;
            dgvAccounts.Columns["CreatedDate"].Width = 100;

            // Format columns
            dgvAccounts.Columns["LastLogin"].DefaultCellStyle.Format = "dd/MM/yyyy HH:mm";
            dgvAccounts.Columns["CreatedDate"].DefaultCellStyle.Format = "dd/MM/yyyy";
            dgvAccounts.Columns["LoginAttempts"].DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleCenter;
            dgvAccounts.Columns["EffectivePermissionCount"].DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleCenter;

            mainPanel.Controls.Add(dgvAccounts);
        }

        private void CreateButtonPanel()
        {
            buttonPanel = new Panel
            {
                Dock = DockStyle.Bottom,
                Height = 60,
                BackColor = Color.FromArgb(248, 249, 250),
                Padding = new Padding(20, 15, 20, 15)
            };

            btnAdd = CreateButton("Tạo Tài Khoản", Color.FromArgb(40, 167, 69), Color.White, 130, 35);
            btnAdd.Location = new Point(0, 0);

            btnEdit = CreateButton("Chỉnh Sửa", Color.FromArgb(255, 193, 7), Color.Black, 120, 35);
            btnEdit.Location = new Point(140, 0);
            btnEdit.Enabled = false;

            btnResetPassword = CreateButton("Reset Mật Khẩu", Color.FromArgb(0, 123, 255), Color.White, 130, 35);
            btnResetPassword.Location = new Point(270, 0);
            btnResetPassword.Enabled = false;

            btnLockUnlock = CreateButton("Khóa/Mở", Color.FromArgb(220, 53, 69), Color.White, 100, 35);
            btnLockUnlock.Location = new Point(410, 0);
            btnLockUnlock.Enabled = false;

            btnPermissions = CreateButton("Phân Quyền", Color.FromArgb(102, 16, 242), Color.White, 120, 35);
            btnPermissions.Location = new Point(520, 0);
            btnPermissions.Enabled = false;

            buttonPanel.Controls.AddRange(new Control[] { 
                btnAdd, btnEdit, btnResetPassword, btnLockUnlock, btnPermissions 
            });

            mainPanel.Controls.Add(buttonPanel);
        }

        private void SetupEventHandlers()
        {
            btnSearch.Click += async (s, e) => await SearchAccounts();
            btnRefresh.Click += async (s, e) => await LoadDataAsync();
            btnAdd.Click += (s, e) => CreateAccount();
            btnEdit.Click += (s, e) => EditAccount();
            btnResetPassword.Click += async (s, e) => await ResetPassword();
            btnLockUnlock.Click += async (s, e) => await ToggleLockAccount();
            btnPermissions.Click += (s, e) => ManagePermissions();

            dgvAccounts.SelectionChanged += (s, e) =>
            {
                bool hasSelection = dgvAccounts.SelectedRows.Count > 0;
                btnEdit.Enabled = hasSelection;
                btnResetPassword.Enabled = hasSelection;
                btnLockUnlock.Enabled = hasSelection;
                btnPermissions.Enabled = hasSelection;

                // Update lock/unlock button text
                if (hasSelection)
                {
                    var isLocked = Convert.ToBoolean(dgvAccounts.SelectedRows[0].Cells["IsLocked"].Value);
                    btnLockUnlock.Text = isLocked ? "Mở Khóa" : "Khóa TK";
                    btnLockUnlock.BackColor = isLocked ? Color.FromArgb(40, 167, 69) : Color.FromArgb(220, 53, 69);
                }
            };

            dgvAccounts.CellDoubleClick += (s, e) =>
            {
                if (e.RowIndex >= 0)
                {
                    EditAccount();
                }
            };

            txtSearch.KeyPress += async (s, e) =>
            {
                if (e.KeyChar == (char)Keys.Enter)
                {
                    await SearchAccounts();
                }
            };
        }

        protected override async Task LoadDataAsync()
        {
            await ExecuteWithLoadingAsync(async () =>
            {
                // Load filter data
                await LoadFilterData();

                // Load accounts
                var response = await _accountService.GetAccountsAsync();
                if (response.Success)
                {
                    UpdateAccountGrid(response.Data);
                    HideLoading($"Đã tải {response.Data.Count} tài khoản");
                }
                else
                {
                    ShowError(response.Message);
                }
            });
        }

        private async Task LoadFilterData()
        {
            // Load roles
            cbRole.Items.Clear();
            cbRole.Items.Add("Tất cả vai trò");
            cbRole.Items.Add("System Admin");
            cbRole.Items.Add("Branch Manager");
            cbRole.Items.Add("Department Manager");
            cbRole.Items.Add("Teacher");
            cbRole.Items.Add("Staff");
            cbRole.Items.Add("Accountant");
            cbRole.Items.Add("Student Advisor");
            cbRole.SelectedIndex = 0;

            // Load status
            cbStatus.Items.Clear();
            cbStatus.Items.Add("Tất cả trạng thái");
            cbStatus.Items.Add("Active");
            cbStatus.Items.Add("Inactive");
            cbStatus.Items.Add("Pending");
            cbStatus.SelectedIndex = 0;
        }

        private async Task SearchAccounts()
        {
            var searchTerm = txtSearch.Text;
            if (searchTerm == "Nhập tên, email hoặc mã nhân viên...")
                searchTerm = "";

            var roleFilter = cbRole.SelectedItem.ToString();
            if (roleFilter == "Tất cả vai trò") roleFilter = null;

            var statusFilter = cbStatus.SelectedItem.ToString();
            if (statusFilter == "Tất cả trạng thái") statusFilter = null;

            await ExecuteWithLoadingAsync(async () =>
            {
                var response = await _accountService.GetAccountsAsync(searchTerm);
                if (response.Success)
                {
                    // TODO: Apply role and status filters
                    var filteredAccounts = response.Data;
                    
                    UpdateAccountGrid(filteredAccounts);
                    HideLoading($"Tìm thấy {filteredAccounts.Count} tài khoản");
                }
                else
                {
                    ShowError(response.Message);
                }
            });
        }

        private void UpdateAccountGrid(System.Collections.Generic.List<Account> accounts)
        {
            dgvAccounts.Rows.Clear();

            foreach (var account in accounts)
            {
                var rowIndex = dgvAccounts.Rows.Add(
                    account.AccountID,
                    account.StaffCode,
                    account.FullName,
                    account.Username,
                    account.Email,
                    account.RoleName ?? "",
                    account.AccountStatus,
                    account.LastLogin,
                    account.IsLocked ? "Có" : "Không",
                    account.LoginAttempts,
                    account.EffectivePermissionCount,
                    account.CreatedDate
                );

                var row = dgvAccounts.Rows[rowIndex];

                // Color coding based on account status
                if (account.IsLocked)
                {
                    row.DefaultCellStyle.BackColor = Color.FromArgb(255, 220, 220);
                    row.DefaultCellStyle.ForeColor = Color.Red;
                }
                else if (account.AccountStatus == "Inactive")
                {
                    row.DefaultCellStyle.BackColor = Color.FromArgb(248, 249, 250);
                    row.DefaultCellStyle.ForeColor = Color.Gray;
                }
                else if (account.LoginAttempts > 3)
                {
                    row.DefaultCellStyle.BackColor = Color.FromArgb(255, 248, 220);
                }

                // Highlight accounts requiring password reset
                if (account.PasswordResetRequired)
                {
                    row.Cells["Username"].Style.BackColor = Color.Orange;
                    row.Cells["Username"].Style.ForeColor = Color.White;
                }

                // Highlight first-time login accounts
                if (account.FirstLoginChangePwd)
                {
                    row.Cells["LastLogin"].Style.BackColor = Color.LightBlue;
                }
            }
        }

        private void CreateAccount()
        {
            var createForm = new AccountCreateForm();
            if (createForm.ShowDialog() == DialogResult.OK)
            {
                _ = LoadDataAsync(); // Refresh grid
            }
        }

        private void EditAccount()
        {
            if (dgvAccounts.SelectedRows.Count > 0)
            {
                var accountId = (int)dgvAccounts.SelectedRows[0].Cells["AccountID"].Value;
                var editForm = new AccountEditForm(accountId);
                if (editForm.ShowDialog() == DialogResult.OK)
                {
                    _ = LoadDataAsync(); // Refresh grid
                }
            }
        }

        private async Task ResetPassword()
        {
            if (dgvAccounts.SelectedRows.Count > 0)
            {
                var username = dgvAccounts.SelectedRows[0].Cells["Username"].Value.ToString();
                var accountId = (int)dgvAccounts.SelectedRows[0].Cells["AccountID"].Value;

                var result = MessageBox.Show(
                    $"Bạn có chắc chắn muốn reset mật khẩu cho tài khoản '{username}'?",
                    "Xác nhận reset mật khẩu",
                    MessageBoxButtons.YesNo,
                    MessageBoxIcon.Question);

                if (result == DialogResult.Yes)
                {
                    await ExecuteWithLoadingAsync(async () =>
                    {
                        // TODO: Implement password reset API call
                        var response = await _accountService.UpdateAccountAsync(
                            accountId, 
                            dgvAccounts.SelectedRows[0].Cells["Email"].Value.ToString(),
                            dgvAccounts.SelectedRows[0].Cells["FullName"].Value.ToString(),
                            false, // isLocked
                            true   // passwordResetRequired
                        );

                        if (response.Success)
                        {
                            ShowSuccess($"Đã reset mật khẩu cho tài khoản '{username}'. Mật khẩu mới sẽ được gửi qua email.");
                            await LoadDataAsync();
                        }
                        else
                        {
                            ShowError(response.Message);
                        }
                    });
                }
            }
        }

        private async Task ToggleLockAccount()
        {
            if (dgvAccounts.SelectedRows.Count > 0)
            {
                var username = dgvAccounts.SelectedRows[0].Cells["Username"].Value.ToString();
                var accountId = (int)dgvAccounts.SelectedRows[0].Cells["AccountID"].Value;
                var isCurrentlyLocked = Convert.ToBoolean(dgvAccounts.SelectedRows[0].Cells["IsLocked"].Value);
                var action = isCurrentlyLocked ? "mở khóa" : "khóa";

                var result = MessageBox.Show(
                    $"Bạn có chắc chắn muốn {action} tài khoản '{username}'?",
                    $"Xác nhận {action} tài khoản",
                    MessageBoxButtons.YesNo,
                    MessageBoxIcon.Question);

                if (result == DialogResult.Yes)
                {
                    await ExecuteWithLoadingAsync(async () =>
                    {
                        var response = await _accountService.UpdateAccountAsync(
                            accountId,
                            dgvAccounts.SelectedRows[0].Cells["Email"].Value.ToString(),
                            dgvAccounts.SelectedRows[0].Cells["FullName"].Value.ToString(),
                            !isCurrentlyLocked, // toggle lock status
                            false
                        );

                        if (response.Success)
                        {
                            ShowSuccess($"Đã {action} tài khoản '{username}' thành công");
                            await LoadDataAsync();
                        }
                        else
                        {
                            ShowError(response.Message);
                        }
                    });
                }
            }
        }

        private void ManagePermissions()
        {
            if (dgvAccounts.SelectedRows.Count > 0)
            {
                var accountId = (int)dgvAccounts.SelectedRows[0].Cells["AccountID"].Value;
                var username = dgvAccounts.SelectedRows[0].Cells["Username"].Value.ToString();
                
                var permissionForm = new PermissionManagementForm(accountId, username);
                permissionForm.Show();
            }
        }
    }

    // Placeholder forms
    public class AccountCreateForm : Form
    {
        public AccountCreateForm()
        {
            Text = "Tạo Tài Khoản Mới";
            Size = new Size(600, 500);
            StartPosition = FormStartPosition.CenterParent;

            var label = new Label
            {
                Text = "Form tạo tài khoản mới sẽ được triển khai với API integration",
                Location = new Point(50, 50),
                AutoSize = true
            };

            var btnOK = new Button
            {
                Text = "Tạo",
                DialogResult = DialogResult.OK,
                Location = new Point(200, 400),
                Size = new Size(100, 35)
            };

            var btnCancel = new Button
            {
                Text = "Hủy",
                DialogResult = DialogResult.Cancel,
                Location = new Point(320, 400),
                Size = new Size(100, 35)
            };

            Controls.AddRange(new Control[] { label, btnOK, btnCancel });
        }
    }

    public class AccountEditForm : Form
    {
        public AccountEditForm(int accountId)
        {
            Text = $"Chỉnh Sửa Tài Khoản - ID: {accountId}";
            Size = new Size(600, 500);
            StartPosition = FormStartPosition.CenterParent;

            var label = new Label
            {
                Text = $"Form chỉnh sửa tài khoản ID: {accountId}",
                Location = new Point(50, 50),
                AutoSize = true
            };

            var btnOK = new Button
            {
                Text = "Lưu",
                DialogResult = DialogResult.OK,
                Location = new Point(200, 400),
                Size = new Size(100, 35)
            };

            var btnCancel = new Button
            {
                Text = "Hủy",
                DialogResult = DialogResult.Cancel,
                Location = new Point(320, 400),
                Size = new Size(100, 35)
            };

            Controls.AddRange(new Control[] { label, btnOK, btnCancel });
        }
    }

    public class PermissionManagementForm : Form
    {
        public PermissionManagementForm(int accountId, string username)
        {
            Text = $"Quản Lý Quyền - {username}";
            Size = new Size(800, 600);
            StartPosition = FormStartPosition.CenterParent;

            var label = new Label
            {
                Text = $"Form quản lý quyền cho tài khoản {username} (ID: {accountId})",
                Location = new Point(50, 50),
                AutoSize = true
            };

            Controls.Add(label);
        }
    }
}