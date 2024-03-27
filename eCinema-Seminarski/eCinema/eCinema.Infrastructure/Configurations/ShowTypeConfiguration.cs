using eCinema.Core.Entities;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace eCinema.Infrastructure.Configurations
{
    public class ShowTypeConfiguration : BaseConfiguration<ShowType>
    {
        public override void Configure(EntityTypeBuilder<ShowType> builder)
        {
            base.Configure(builder);

            builder.Property(e => e.Name)
                     .IsRequired();
        }
    }
}
