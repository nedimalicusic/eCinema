using eCinema.Core.Entities;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace eCinema.Infrastructure.Configurations
{
    public class WeekDayConfiguration : BaseConfiguration<WeekDay>
    {
        public override void Configure(EntityTypeBuilder<WeekDay> builder)
        {
            base.Configure(builder);


            builder.Property(e => e.Name)
                   .IsRequired();
        }
    }
}
