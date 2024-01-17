using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace eCinema.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class edit : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.RenameColumn(
                name: "isConfirmed",
                table: "Reservations",
                newName: "IsClosed");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.RenameColumn(
                name: "IsClosed",
                table: "Reservations",
                newName: "isConfirmed");
        }
    }
}
