using eCinema.Core;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace eCinema.Infrastructure
{
    public class EmployeeConfiguration : BaseConfiguration<Employee>
    {
        public override void Configure(EntityTypeBuilder<Employee> builder)
        {
            base.Configure(builder);

            builder.Property(e => e.FirstName)
              .IsRequired();

            builder.Property(e => e.LastName)
              .IsRequired();

            builder.Property(e => e.Email)
              .IsRequired();

            builder.Property(e => e.BirthDate)
              .IsRequired();

            builder.Property(e => e.Gender)
              .IsRequired();

            builder.Property(e => e.isActive)
            .IsRequired();

            builder.HasOne(e => e.ProfilePhoto)
                .WithMany(e => e.Employees)
                .HasForeignKey(e => e.ProfilePhotoId)
                .IsRequired(false);

            builder.HasOne(e => e.Cinema)
                .WithMany(e => e.Employees)
                .HasForeignKey(e => e.CinemaId)
                .IsRequired();

        }
    }
}
