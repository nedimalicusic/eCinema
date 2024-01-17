using eCinema.Core;

namespace eCinema.Application
{
    public class ProductionProfile : BaseProfile
    {
        public ProductionProfile()
        {
            CreateMap<ProductionDto, Production>().ReverseMap();

            CreateMap<ProductionUpsertDto, Production>();
        }
    }
}
