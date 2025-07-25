using System;
using System.Drawing;
using System.Linq;
using System.Threading.Tasks;
using System.Windows.Forms;
using HHMS_Application.Services;
using HHMS_Application.Models;

namespace HHMS_Application.Forms
{
    public class StaffListForm : BaseAPIForm
    {
        private readonly StaffService _staffService;

        // Controls
        private Panel searchPanel;
        private TextBox txtSearch;
        private ComboBox cbDepartment;
        private ComboBox cbBranch;
        private Button btnSearch;
        private Button btnAdd;
        private Button btnEdit;
        private Button btnDelete;
        private Button btnRefresh;

        private DataGridView dgvStaff;
        private Panel buttonPanel;

        public StaffListForm() : base("Quản Lý Nhân Viên")
        {
            _staffService = new StaffService();
        }

        protected override void InitializeFormControls()
        {
            CreateSearchPanel();
            CreateButtonPanel();
            CreateDataGrid();
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

            txtSearch = CreateTextBox("Nhập mã nhân viên, tên hoặc email...");
            txtSearch.Location = new Point(80, 5);
            txtSearch.Width = 250;

            var deptLabel = new Label
            {
                Text = "Phòng ban:",
                Font = new Font("Segoe UI", 10, FontStyle.Bold),
                Location = new Point(350, 8),
                AutoSize = true
            };

            cbDepartment = CreateComboBox();
            cbDepartment.Location = new Point(430, 5);
            cbDepartment.Width = 150;

            var branchLabel = new Label
            {
                Text = "Chi nhánh:",
                Font = new Font("Segoe UI", 10, FontStyle.Bold),
                Location = new Point(600, 8),
                AutoSize = true
            };

            cbBranch = CreateComboBox();
            cbBranch.Location = new Point(680, 5);
            cbBranch.Width = 150;

            btnSearch = CreateButton("Tìm Kiếm", Color.FromArgb(0, 123, 255), Color.White, 100, 30);
            btnSearch.Location = new Point(850, 5);

            btnRefresh = CreateButton("Làm Mới", Color.FromArgb(108, 117, 125), Color.White, 100, 30);
            btnRefresh.Location = new Point(960, 5);

            searchPanel.Controls.AddRange(new Control[] {
                searchLabel, txtSearch, deptLabel, cbDepartment, branchLabel, cbBranch, btnSearch, btnRefresh
            });

            mainPanel.Controls.Add(searchPanel);
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

            btnAdd = CreateButton("Thêm Mới", Color.FromArgb(40, 167, 69), Color.White, 120, 35);
            btnAdd.Location = new Point(0, 0);

            btnEdit = CreateButton("Chỉnh Sửa", Color.FromArgb(255, 193, 7), Color.Black, 120, 35);
            btnEdit.Location = new Point(130, 0);
            btnEdit.Enabled = false;

            btnDelete = CreateButton("Xóa", Color.FromArgb(220, 53, 69), Color.White, 120, 35);
            btnDelete.Location = new Point(260, 0);
            btnDelete.Enabled = false;

            var btnSalary = CreateButton("Quản Lý Lương", Color.FromArgb(102, 16, 242), Color.White, 120, 35);
            btnSalary.Location = new Point(390, 0);
            btnSalary.Click += (s, e) => ManageSalary();

            buttonPanel.Controls.AddRange(new Control[] { btnAdd, btnEdit, btnDelete, btnSalary });
            mainPanel.Controls.Add(buttonPanel);
        }

        private void CreateDataGrid()
        {
            dgvStaff = CreateDataGridView();
            dgvStaff.Dock = DockStyle.Fill;

            // Add columns
            dgvStaff.Columns.Add("StaffID", "ID");
            dgvStaff.Columns.Add("StaffCode", "Mã NV");
            dgvStaff.Columns.Add("FullName", "Họ Tên");
            dgvStaff.Columns.Add("Gender", "Giới Tính");
            dgvStaff.Columns.Add("Position", "Chức Vụ");
            dgvStaff.Columns.Add("Phone", "Điện Thoại");
            dgvStaff.Columns.Add("Email", "Email");
            dgvStaff.Columns.Add("ContractType", "Loại HĐ");
            dgvStaff.Columns.Add("HireDate", "Ngày Vào");
            dgvStaff.Columns.Add("BaseSalary", "Lương Cơ Bản");
            dgvStaff.Columns.Add("DepartmentName", "Phòng Ban");
            dgvStaff.Columns.Add("BranchName", "Chi Nhánh");

            // Hide ID column
            dgvStaff.Columns["StaffID"].Visible = false;

            // Set column widths
            dgvStaff.Columns["StaffCode"].Width = 100;
            dgvStaff.Columns["FullName"].Width = 180;
            dgvStaff.Columns["Gender"].Width = 70;
            dgvStaff.Columns["Position"].Width = 120;
            dgvStaff.Columns["Phone"].Width = 120;
            dgvStaff.Columns["Email"].Width = 200;
            dgvStaff.Columns["ContractType"].Width = 100;
            dgvStaff.Columns["HireDate"].Width = 100;
            dgvStaff.Columns["BaseSalary"].Width = 120;
            dgvStaff.Columns["DepartmentName"].Width = 150;
            dgvStaff.Columns["BranchName"].Width = 150;

            // Format salary column
            dgvStaff.Columns["BaseSalary"].DefaultCellStyle.Format = "C0";
            dgvStaff.Columns["BaseSalary"].DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight;

            mainPanel.Controls.Add(dgvStaff);
        }

        private void SetupEventHandlers()
        {
            btnSearch.Click += async (s, e) => await SearchStaff();
            btnRefresh.Click += async (s, e) => await LoadDataAsync();
            btnAdd.Click += (s, e) => AddStaff();
            btnEdit.Click += (s, e) => EditStaff();
            btnDelete.Click += async (s, e) => await DeleteStaff();

            dgvStaff.SelectionChanged += (s, e) =>
            {
                bool hasSelection = dgvStaff.SelectedRows.Count > 0;
                btnEdit.Enabled = hasSelection;
                btnDelete.Enabled = hasSelection;
            };

            dgvStaff.CellDoubleClick += (s, e) =>
            {
                if (e.RowIndex >= 0)
                {
                    EditStaff();
                }
            };

            txtSearch.KeyPress += async (s, e) =>
            {
                if (e.KeyChar == (char)Keys.Enter)
                {
                    await SearchStaff();
                }
            };
        }

        protected override async Task LoadDataAsync()
        {
            await ExecuteWithLoadingAsync(async () =>
            {
                // Load departments and branches for filters
                await LoadFilters();

                // Load staff
                var response = await _staffService.GetAllStaffAsync();
                if (response.Success)
                {
                    UpdateStaffGrid(response.Data);
                    HideLoading($"Đã tải {response.Data.Count} nhân viên");
                }
                else
                {
                    ShowError(response.Message);
                }
            });
        }

        private async Task LoadFilters()
        {
            // Load departments
            cbDepartment.Items.Clear();
            cbDepartment.Items.Add("Tất cả phòng ban");
            cbDepartment.Items.Add("Nhân sự");
            cbDepartment.Items.Add("Giáo vụ");
            cbDepartment.Items.Add("Tài chính");
            cbDepartment.Items.Add("Công nghệ thông tin");
            cbDepartment.Items.Add("Marketing");
            cbDepartment.SelectedIndex = 0;

            // Load branches
            cbBranch.Items.Clear();
            cbBranch.Items.Add("Tất cả chi nhánh");
            cbBranch.Items.Add("Chi nhánh Hà Nội");
            cbBranch.Items.Add("Chi nhánh TP.HCM");
            cbBranch.Items.Add("Chi nhánh Đà Nẵng");
            cbBranch.SelectedIndex = 0;
        }

        private async Task SearchStaff()
        {
            var searchTerm = txtSearch.Text;
            if (searchTerm == "Nhập mã nhân viên, tên hoặc email...")
                searchTerm = "";

            await ExecuteWithLoadingAsync(async () =>
            {
                var response = await _staffService.GetAllStaffAsync(searchTerm);
                if (response.Success)
                {
                    UpdateStaffGrid(response.Data);
                    HideLoading($"Tìm thấy {response.Data.Count} nhân viên");
                }
                else
                {
                    ShowError(response.Message);
                }
            });
        }

        private void UpdateStaffGrid(System.Collections.Generic.List<Staff> staffList)
        {
            dgvStaff.Rows.Clear();

            foreach (var staff in staffList)
            {
                var rowIndex = dgvStaff.Rows.Add(
                    staff.StaffID,
                    staff.StaffCode,
                    staff.FullName,
                    staff.Gender ?? "",
                    staff.Position ?? "",
                    staff.Phone ?? "",
                    staff.Email ?? "",
                    staff.ContractType ?? "",
                    staff.HireDate.ToString("dd/MM/yyyy"),
                    staff.BaseSalary,
                    "", // DepartmentName - will be populated when we have department data
                    ""  // BranchName - will be populated when we have branch data
                );

                // Color coding for different contract types
                if (staff.ContractType == "Part-time")
                {
                    dgvStaff.Rows[rowIndex].DefaultCellStyle.BackColor = Color.FromArgb(255, 248, 220);
                }
                else if (staff.ContractType == "Contract")
                {
                    dgvStaff.Rows[rowIndex].DefaultCellStyle.BackColor = Color.FromArgb(240, 248, 255);
                }

                // Inactive staff
                if (staff.StatusID != 1)
                {
                    dgvStaff.Rows[rowIndex].DefaultCellStyle.BackColor = Color.FromArgb(248, 249, 250);
                    dgvStaff.Rows[rowIndex].DefaultCellStyle.ForeColor = Color.Gray;
                }
            }
        }

        private void AddStaff()
        {
            var addForm = new StaffEditForm();
            if (addForm.ShowDialog() == DialogResult.OK)
            {
                _ = LoadDataAsync(); // Refresh grid
            }
        }

        private void EditStaff()
        {
            if (dgvStaff.SelectedRows.Count > 0)
            {
                var staffId = (int)dgvStaff.SelectedRows[0].Cells["StaffID"].Value;
                var editForm = new StaffEditForm(staffId);
                if (editForm.ShowDialog() == DialogResult.OK)
                {
                    _ = LoadDataAsync(); // Refresh grid
                }
            }
        }

        private async Task DeleteStaff()
        {
            if (dgvStaff.SelectedRows.Count > 0)
            {
                var staffName = dgvStaff.SelectedRows[0].Cells["FullName"].Value.ToString();
                var result = MessageBox.Show(
                    $"Bạn có chắc chắn muốn xóa nhân viên '{staffName}'?",
                    "Xác nhận xóa",
                    MessageBoxButtons.YesNo,
                    MessageBoxIcon.Question);

                if (result == DialogResult.Yes)
                {
                    var staffId = (int)dgvStaff.SelectedRows[0].Cells["StaffID"].Value;
                    
                    await ExecuteWithLoadingAsync(async () =>
                    {
                        var response = await _staffService.DeleteStaffAsync(staffId);
                        if (response.Success)
                        {
                            ShowSuccess("Xóa nhân viên thành công");
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

        private void ManageSalary()
        {
            if (dgvStaff.SelectedRows.Count > 0)
            {
                var staffId = (int)dgvStaff.SelectedRows[0].Cells["StaffID"].Value;
                var staffName = dgvStaff.SelectedRows[0].Cells["FullName"].Value.ToString();
                
                var salaryForm = new SalaryManagementForm(staffId, staffName);
                salaryForm.Show();
            }
            else
            {
                ShowWarning("Vui lòng chọn nhân viên để quản lý lương");
            }
        }
    }

    // Placeholder for Staff Edit Form
    public class StaffEditForm : Form
    {
        public StaffEditForm(int? staffId = null)
        {
            Text = staffId.HasValue ? "Chỉnh Sửa Nhân Viên" : "Thêm Nhân Viên Mới";
            Size = new Size(700, 600);
            StartPosition = FormStartPosition.CenterParent;

            // TODO: Implement staff edit form with API integration
            var label = new Label
            {
                Text = "Form chỉnh sửa nhân viên sẽ được triển khai với API integration",
                Location = new Point(50, 50),
                AutoSize = true
            };

            var btnOK = new Button
            {
                Text = "OK",
                DialogResult = DialogResult.OK,
                Location = new Point(250, 500),
                Size = new Size(100, 35)
            };

            var btnCancel = new Button
            {
                Text = "Hủy",
                DialogResult = DialogResult.Cancel,
                Location = new Point(370, 500),
                Size = new Size(100, 35)
            };

            Controls.AddRange(new Control[] { label, btnOK, btnCancel });
        }
    }

    // Placeholder for Salary Management Form
    public class SalaryManagementForm : Form
    {
        public SalaryManagementForm(int staffId, string staffName)
        {
            Text = $"Quản Lý Lương - {staffName}";
            Size = new Size(800, 600);
            StartPosition = FormStartPosition.CenterParent;

            // TODO: Implement salary management form with API integration
            var label = new Label
            {
                Text = $"Form quản lý lương cho nhân viên {staffName} (ID: {staffId})",
                Location = new Point(50, 50),
                AutoSize = true
            };

            Controls.Add(label);
        }
    }
}