using eCinema.Core;

namespace eCinema.Application
{
    public class CityProfile : BaseProfile
    {
        public CityProfile()
        {
            CreateMap<CityDto, City>().ReverseMap();

            CreateMap<CityUpsertDto, City>();
        }
    }
}
