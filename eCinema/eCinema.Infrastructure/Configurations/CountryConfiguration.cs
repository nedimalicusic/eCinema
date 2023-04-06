using eCinema.Core;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace eCinema.Infrastructure
{
    public class CountryConfiguration : BaseConfiguration<Country>
    {
        public override void Configure(EntityTypeBuilder<Country> builder)
        {
            base.Configure(builder);

            builder.Property(e => e.Name)
                  .IsRequired();

            builder.Property(e => e.Abbreviation)
                   .IsRequired();

            builder.Property(e => e.IsActive)
                   .IsRequired();
        }
    }
}
